#!/usr/bin/env python3
"""d16 roller for tabletop-style roleplay.

Usage examples:
    python3 d16_roll.py --mod 2 --dc 12 --label "Shoot the raider"
    python3 d16_roll.py --mod 1 --dc 10 --adv
    python3 d16_roll.py --mod 0 --dc 14 --dis
    python3 d16_roll.py --mod 3 --opposed-mod 2 --label "Grapple vs raider"
    python3 d16_roll.py --raw 3                    # three plain d16 rolls
    python3 d16_roll.py --mod 2 --dc 12 --short    # outcome word only
    python3 d16_roll.py --mod 2 --dc 12 --json     # full JSON output

Default output is one ready-to-paste line:
    [d16: 11 +2 = 13 vs DC 12 -> success]
    [d16 adv: 4,15 -> 15 +1 = 16 vs DC 10 -> strong_success]
    [d16 opposed: 9 +3 = 12 vs 13 +2 = 15 -> opponent]
    [d16 raw: 7 6 12]
With --short, only the outcome is printed as a plain word:
    check   -> critical_success | strong_success | success | failure |
               bad_failure | critical_failure
    opposed -> actor | opponent | tie
    raw     -> space-separated numbers
With --json, one JSON object is printed instead.
Randomness comes from the OS (SystemRandom), so results cannot be guessed
or replayed.
"""

import argparse
import json
import random
import sys

SIDES = 16
CRIT_SUCCESS = 16   # natural 16
CRIT_FAIL = 1       # natural 1
STRONG_MARGIN = 5   # beat or miss the DC by this much for a strong result

rng = random.SystemRandom()


def roll_die():
    """Roll one d16."""
    return rng.randint(1, SIDES)


def roll_with_mode(mode):
    """Roll a d16 with optional advantage or disadvantage.

    Returns (kept, all_rolls). In 'adv' mode the highest of two rolls is
    kept, in 'dis' mode the lowest, otherwise a single roll is used.
    """
    if mode == "normal":
        value = roll_die()
        return value, [value]
    first, second = roll_die(), roll_die()
    kept = max(first, second) if mode == "adv" else min(first, second)
    return kept, [first, second]


def grade(natural, total, dc):
    """Return the outcome label for a check against a fixed DC."""
    if natural == CRIT_SUCCESS:
        return "critical_success"
    if natural == CRIT_FAIL:
        return "critical_failure"
    margin = total - dc
    if margin >= STRONG_MARGIN:
        return "strong_success"
    if margin >= 0:
        return "success"
    if margin <= -STRONG_MARGIN:
        return "bad_failure"
    return "failure"


def check(args):
    """Resolve a single check against a DC."""
    mode = "adv" if args.adv else "dis" if args.dis else "normal"
    natural, rolls = roll_with_mode(mode)
    total = natural + args.mod
    return {
        "type": "check",
        "label": args.label,
        "mode": mode,
        "rolls": rolls,
        "natural": natural,
        "modifier": args.mod,
        "total": total,
        "dc": args.dc,
        "margin": total - args.dc,
        "outcome": grade(natural, total, args.dc),
    }


def opposed(args):
    """Resolve an opposed check: both sides roll d16 + modifier."""
    mode = "adv" if args.adv else "dis" if args.dis else "normal"
    nat_a, rolls_a = roll_with_mode(mode)
    nat_b, rolls_b = roll_with_mode("normal")
    total_a = nat_a + args.mod
    total_b = nat_b + args.opposed_mod
    if total_a > total_b:
        winner = "actor"
    elif total_b > total_a:
        winner = "opponent"
    else:
        winner = "tie"  # ties favor the defender by table rule
    return {
        "type": "opposed",
        "label": args.label,
        "actor": {"rolls": rolls_a, "natural": nat_a,
                  "modifier": args.mod, "total": total_a},
        "opponent": {"rolls": rolls_b, "natural": nat_b,
                     "modifier": args.opposed_mod, "total": total_b},
        "winner": winner,
        "margin": abs(total_a - total_b),
        "crit_actor": nat_a == CRIT_SUCCESS,
        "fumble_actor": nat_a == CRIT_FAIL,
    }


def raw(count):
    """Roll plain d16 dice with no check logic."""
    return {"type": "raw", "rolls": [roll_die() for _ in range(count)]}


def short_output(result):
    """Return the minimal plain-text outcome for a result dict."""
    if result["type"] == "check":
        return result["outcome"]
    if result["type"] == "opposed":
        return result["winner"]
    return " ".join(str(r) for r in result["rolls"])


def fmt_mod(value):
    """Format a modifier with an explicit sign."""
    return f"{value:+d}"


def line_output(result):
    """Return a ready-to-paste bracketed line for a result dict."""
    if result["type"] == "raw":
        return "[d16 raw: " + " ".join(str(r) for r in result["rolls"]) + "]"
    if result["type"] == "opposed":
        a, b = result["actor"], result["opponent"]
        return (f"[d16 opposed: {a['natural']} {fmt_mod(a['modifier'])} = "
                f"{a['total']} vs {b['natural']} {fmt_mod(b['modifier'])} = "
                f"{b['total']} -> {result['winner']}]")
    mode = "" if result["mode"] == "normal" else " " + result["mode"]
    if len(result["rolls"]) == 2:
        dice = ",".join(str(r) for r in result["rolls"]) + f" -> {result['natural']}"
    else:
        dice = str(result["natural"])
    return (f"[d16{mode}: {dice} {fmt_mod(result['modifier'])} = "
            f"{result['total']} vs DC {result['dc']} -> {result['outcome']}]")


def parse_args(argv):
    p = argparse.ArgumentParser(description="d16 roller")
    p.add_argument("--mod", type=int, default=0, help="roll modifier")
    p.add_argument("--dc", type=int, help="difficulty class (1-20)")
    p.add_argument("--opposed-mod", type=int, default=None,
                   help="enables an opposed check with this opponent modifier")
    p.add_argument("--adv", action="store_true", help="advantage")
    p.add_argument("--dis", action="store_true", help="disadvantage")
    p.add_argument("--raw", type=int, metavar="N", help="roll N plain d16")
    p.add_argument("--label", default="", help="short description of the roll")
    p.add_argument("--short", action="store_true",
                   help="print only the outcome word (no numbers)")
    p.add_argument("--json", action="store_true",
                   help="print the full result as JSON")
    args = p.parse_args(argv)
    if args.adv and args.dis:
        p.error("advantage and disadvantage cancel out; pass neither")
    if args.raw is None and args.opposed_mod is None and args.dc is None:
        p.error("provide --dc, --opposed-mod, or --raw")
    return args


def main(argv):
    args = parse_args(argv)
    if args.raw is not None:
        result = raw(max(1, min(args.raw, 20)))
    elif args.opposed_mod is not None:
        result = opposed(args)
    else:
        result = check(args)
    if args.json:
        print(json.dumps(result))
    elif args.short:
        print(short_output(result))
    else:
        print(line_output(result))


if __name__ == "__main__":
    main(sys.argv[1:])
