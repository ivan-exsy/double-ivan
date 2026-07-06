import re
from pathlib import Path

total = 83.36
raw = Path(__file__).with_name("script_used.txt").read_text(encoding="utf-8")
def _norm_tokens(s: str):
    return re.sub(r"[^\w\s'-]", " ", s).split()


words_all = _norm_tokens(re.sub(r"\[[^\]]+\]\s*", "", raw))

blocks = [
    (
        "Hook",
        "What if you had a second chance to make it right? What if you could practice that hard conversation — before it ever happened? What if you had a Double? An AI version of you. Talking like you. Choosing like you.",
    ),
    (
        "Concept",
        "In Doubland, you build an AI Double from your personality. Then you watch it live, in a world with other Doubles. Every conversation. Every choice. Every relationship.",
    ),
    (
        "L-Talks reveal",
        "This season: L-Talks. Three hundred voices in one alumni chat. We read a year of messages. Picked the fifteen most active. Built their Doubles from what they actually said — no surveys, no interviews. Dropped them in. And pressed play.",
    ),
    (
        "Cast",
        "Fifteen Doubles. AI versions of real people. No one at the keyboard.",
    ),
    (
        "Survival",
        "The show is on — in Survival Mode. Every day, one Double gets eliminated — until only one remains.",
    ),
    (
        "Closing",
        "Watch live 24/7. Follow any Double. See who survives. It's real pressure, real choices. They surprise you. And after a while... you start to wonder — what would MY Double do?",
    ),
]


def wc(s: str) -> int:
    return len(_norm_tokens(s))


from typing import Optional


def word_index(phrase: str) -> Optional[int]:
    aw = _norm_tokens(phrase)
    for i in range(len(words_all) - len(aw) + 1):
        if words_all[i : i + len(aw)] == aw:
            return i
    return None


def sec_at_word(i: int) -> float:
    return total * i / len(words_all)


all_w = sum(wc(b[1]) for b in blocks)
t = 0.0
print("BLOCKS")
for name, body in blocks:
    w = wc(body)
    dur = total * w / all_w
    print(f"  {name}: {t:.1f}–{t + dur:.1f}s")
    t += dur

anchors = [
    "What if you had a second chance",
    "before it ever happened",
    "What if you had a Double",
    "An AI version of you",
    "Choosing like you",
    "In Doubland",
    "Every conversation",
    "This season: L-Talks",
    "Three hundred voices",
    "And pressed play",
    "Fifteen Doubles",
    "The show is on",
    "Survival Mode",
    "until only one remains",
    "Watch live 24/7",
    "See who survives",
    "They surprise you",
    "what would MY Double do",
]
print("\nANCHORS")
for a in anchors:
    idx = word_index(a)
    if idx is not None:
        print(f"  {sec_at_word(idx):5.1f}s  {a}")
