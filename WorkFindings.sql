-- WorkFindings.sql for ScoutStig
-- SET @scan_id := 1;

SELECT * FROM v_scan_rules WHERE scan_id=@scan_id;

-- Mark all open
UPDATE stig_finding SET status='open' WHERE scan_id=@scan_id;

-- Reset to not_reviewed
UPDATE stig_finding SET status='not_reviewed' WHERE scan_id=@scan_id;
