# The Join That Passed the Count

A gallery ran three workshops. Its attendance register shows 33 visits. A room report built from that register also shows 33 visits, across the same number of rows. Would you publish the room totals?

| Workshop | Recorded visits | Room assignments on file |
| --- | ---: | --- |
| Clay | 12 | East and West |
| Paper | 9 | North |
| Ink | 12 | None |

Each workshop ran once. Every visit belongs to that workshop, and each workshop should have exactly one confirmed room. A person attending two workshops contributes one visit to each. Predict the rows produced by an inner join on workshop before opening the solution.

<details>
<summary>See the joined rows and the missing workshop</summary>

| Workshop | Room | Visits in the report |
| --- | --- | ---: |
| Clay | East | 12 |
| Clay | West | 12 |
| Paper | North | 9 |

The extra Clay row adds 12. Losing Ink subtracts 12. Both tables now show three rows and 33 visits. The numbers agree because two errors cancel. The room records cannot tell us which Clay assignment is authoritative or where Ink ran.

</details>

## Run the diagnostic

Paste the following into SQLite. It uses inline data and leaves your database unchanged.

```sql
WITH attendance(workshop, visits) AS (
  VALUES ('Clay',12), ('Paper',9), ('Ink',12)
), rooms(workshop, room) AS (
  VALUES ('Clay','East'), ('Clay','West'), ('Paper','North')
)
SELECT a.workshop, a.visits, COUNT(r.room) AS room_matches
FROM attendance AS a
LEFT JOIN rooms AS r ON r.workshop = a.workshop
GROUP BY a.workshop, a.visits
HAVING COUNT(r.room) <> 1
ORDER BY a.workshop;
```

The output is Clay (12 visits, 2 matches) and Ink (12 visits, 0 matches). Starting with attendance preserves the list of expected workshops. An unmatched workshop has a placeholder row after a left join. Counting the room column, which is filled on every real assignment here, gives zero for that placeholder. Counting all rows would give one.

## Two tempting fixes

**Sum distinct values.** On the joined rows, this gives 21: the two different values are 9 and 12. Clay and Ink legitimately have identical attendance. Removing repeated numerical values loses that distinction.

**Choose the first room alphabetically.** This returns a single room for Clay, but alphabetical order provides no evidence that Clay ran there. Ink still needs an assignment. Report total visits from the attendance register when that is the question. For totals by room, resolve the exceptions against the scheduling record, then repeat the per-workshop check. In a multi-day report, workshop names can recur; use the stable session ID from the register.

## Try a different question

Two workshops each welcomed 11 people. The first had two touch stations and the second had one. How many visits were recorded at workshops that offered at least one touch station?

<details>
<summary>Compare your reasoning</summary>

The answer is **22 visits**. Joining the sessions to every matching station produces three rows and 33 visits. Summing distinct attendance values gives 11. Test whether a qualifying station exists for each session, then sum attendance over the qualifying sessions. The goal is to identify eligible sessions; their number of stations never enters the attendance calculation.

</details>

This is an AI-generated educational sample with fictional records. The SQL examples have been checked in SQLite. For the underlying rules, see the [SQLite SELECT reference](https://www.sqlite.org/lang_select.html) and [aggregate function reference](https://www.sqlite.org/lang_aggfunc.html).

[Try the two-page reader exercise and optionally give feedback on a proposed six-case workbook](https://docs.google.com/forms/d/e/1FAIpQLSdXjoH8UdvQhLCgicTV3g0FcwlW3a48i14aS3DDGBwzMjwPwg/viewform). You can read the worked answer without submitting a response.
