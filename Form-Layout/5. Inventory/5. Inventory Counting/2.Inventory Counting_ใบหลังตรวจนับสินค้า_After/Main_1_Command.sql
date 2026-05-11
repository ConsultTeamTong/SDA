SELECT DISTINCT
    T0.DocEntry,
    T1.[VisOrder], T1.[ItemCode], T1.[ItemDesc], T1.[UomCode], T1.[WhsCode], T1.[BinEntry],
    T3.[BinCode],
    T5.DistNumber,                              -- เลขที่ล็อต / Batch No.
    T0.[DocNum],
    T0.[Countdate], T0.[BPLId],
    T7.ItmsGrpNam,
    T5.MnfSerial,
    CASE
        WHEN LEN(T0.Time) = 1 THEN '00:0' + LEFT(T0.Time, 1)
        WHEN LEN(T0.Time) = 2 THEN '00:'  + LEFT(T0.Time, 2)
        WHEN LEN(T0.Time) = 3 THEN '0' + LEFT(T0.Time, 1) + ':' + RIGHT(T0.Time, 2)
        WHEN LEN(T0.Time) = 4 THEN LEFT(T0.Time, 2) + ':' + RIGHT(T0.Time, 2)
    END AS 'TIME',
    T1.InWhsQty                       AS 'InWhsQty',       -- ⭐ สินค้าคงเหลือ (ในระบบ)
    T1.CountQty                       AS 'CountedQty',     -- ⭐ จำนวนนับได้
    (T1.CountQty - T1.InWhsQty)       AS 'Diff',           -- ⭐ ผลต่าง
    T1.CountQtyT1                     AS 'CountQtyT1',     -- จำนวนผู้นับคนที่ 1
    T1.CountQtyT2                     AS 'CountQtyT2',     -- จำนวนผู้นับคนที่ 2
    T1.Counted                        AS 'CountStatus',    -- สถานะนับแล้ว Y/N
    T1.Freeze                         AS 'FreezeStatus',   -- สถานะ Freeze
    T1.Remark                         AS 'Remark',         -- หมายเหตุ
    T9.Quantity                       AS 'CountQtyB',      -- จำนวนนับระดับ Batch/Serial
    T6.UgpEntry,
    T10.UgpName,
    T0.CreateTime,
    T0.UserSign,
    T11.U_NAME,
    CONCAT(OHEM.firstName, ' ', OHEM.middleName, ' ', OHEM.lastname) AS 'CounterName'
FROM OINC T0
LEFT JOIN INC1 T1 ON T0.DocEntry = T1.DocEntry
LEFT JOIN OIBQ T2 ON T1.BinEntry = T2.BinAbs AND T1.ItemCode = T2.ItemCode
LEFT JOIN OBIN T3 ON T1.BinEntry = T3.AbsEntry
LEFT JOIN OBBQ T4 ON T2.BinAbs = T4.BinAbs AND T2.ItemCode = T4.ItemCode AND T4.OnHandQty <> 0
LEFT JOIN OBTN T5 ON T4.SnBMDAbs = T5.AbsEntry AND T4.ItemCode = T5.ItemCode
LEFT JOIN OITM T6 ON T1.ItemCode = T6.ItemCode
LEFT JOIN OITB T7 ON T7.ItmsGrpCod = T6.ItmsGrpCod
LEFT JOIN OBTQ T8 ON T1.ItemCode = T8.ItemCode AND T8.WhsCode = T1.WhsCode AND T8.Quantity <> 0
LEFT JOIN INC3 T9 ON T9.ObjAbs = T8.MdAbsEntry
LEFT JOIN OUGP T10 ON T6.UgpEntry = T10.UgpEntry
LEFT JOIN OUSR T11 ON T0.UserSign = T11.USERID
LEFT JOIN OHEM ON OHEM.empID = T0.Taker1Id
WHERE T0.DocEntry = {?DocKey@}
ORDER BY T1.[VisOrder], T1.[BinEntry]