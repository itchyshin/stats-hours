# 2012 sparrow data — the original R-book files

Recovered 2026-09-06 from the author's own archive folder "Sparrow Data for R-Book" (files dated
November 2009 – March 2010, the drafting period of *Statistical Models with R: An Introduction with
Sparrows*). Line endings normalised from CR to LF; nothing else altered. Row counts below are data rows parsed as CSV
(not `wc -l`, which undercounts files that lack a trailing newline). These are the real house
sparrows (Lundy Island population) that the cast's Itchy works with; they replace the seeded stand-ins
as chapters are re-executed against them.

| file | rows | columns | sha256 (first 16) |
|---|---|---|---|
| Anscombe.csv | 44 | Food,Drink,Type | 61fb5498c07c2437 |
| BodySize.csv | 460 | BirdID,Sex,Tarsus,BillL,BillW,Tail,Wing,Weight | cc8db0435d92c44e |
| ChickSurvival.csv | 1576 | Survival,Sex,Mass2,BroodSize,JulianDate | 7de282fd805664f0 |
| EPPSuccess.csv | 76 | EPP,Age | 6a1f3c9c412bce80 |
| FemaleSuccess.csv | 163 | Fledglings,EggNo,Age | 8f2b2c500b2b59c7 |
| MBodySize.csv | 171 | BirdID,Sex,Tarsus,BillL,BillW,Tail,Wing,Weight | 56cf9fa7a0866fd3 |
| SparrowSurvival.csv | 1950 | ChickNo,Sex,Survival,Mass2,BroodSize,HatchingSuccess,EggNo,JulianDate,Dad,Mum,BroodNo,Year | ce8d77b55174648c |
| meanBodySize.csv | 171 | "BirdID","Sex","Tarsus","BillL","BillW","Tail","Wing","Weight" | bfd87de6609bcb85 |

`Notes.R` is the author's original working script from the same folder, kept for provenance.

Note for chapter 2: BodySize.csv holds repeated measurements per BirdID (171 birds, 460 rows) — the
repeatability data chapter 6 needs; MBodySize.csv / meanBodySize.csv are the one-row-per-bird
versions. Chapter 2's current numbers come from a seeded stand-in and change when it is re-run on
these files; the prose does not.
