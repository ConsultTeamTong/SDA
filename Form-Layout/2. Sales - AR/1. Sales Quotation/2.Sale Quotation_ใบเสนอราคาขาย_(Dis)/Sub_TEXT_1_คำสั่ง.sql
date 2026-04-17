SELECT
    TOP 1 QUT10.LineText
FROM QUT1
INNER JOIN QUT10 ON QUT1.[DocEntry] = QUT10.[DocEntry] AND QUT10.AftLineNum = {?lineNum@}
WHERE QUT1.[DocEntry] = {?DocKey@}
