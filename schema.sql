-- ScoutStig schema.sql
-- MariaDB backend for STIG rule ingestion and manual findings workflow

CREATE TABLE IF NOT EXISTS stig_benchmark (
  benchmark_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  source_filename VARCHAR(255) NOT NULL,
  benchmark_title VARCHAR(255),
  benchmark_version VARCHAR(64),
  release_info VARCHAR(255),
  imported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_benchmark (source_filename, benchmark_version, release_info)
);

CREATE TABLE IF NOT EXISTS stig_rule (
  benchmark_id BIGINT NOT NULL,
  group_id VARCHAR(32) NOT NULL,
  group_title TEXT,
  rule_id VARCHAR(96) NOT NULL,
  rule_version VARCHAR(64),
  rule_title TEXT,
  severity VARCHAR(16),
  weight DECIMAL(10,4),
  check_content LONGTEXT,
  fix_text LONGTEXT,
  ccis JSON,
  srg_id VARCHAR(64),
  PRIMARY KEY (benchmark_id, group_id),
  FOREIGN KEY (benchmark_id) REFERENCES stig_benchmark(benchmark_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS stig_scan (
  scan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  benchmark_id BIGINT NOT NULL,
  target_host VARCHAR(255) NOT NULL,
  target_port INT,
  target_instance VARCHAR(255),
  started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  finished_at TIMESTAMP NULL,
  tool_version VARCHAR(64),
  notes TEXT,
  FOREIGN KEY (benchmark_id) REFERENCES stig_benchmark(benchmark_id)
);

CREATE TABLE IF NOT EXISTS stig_finding (
  scan_id BIGINT NOT NULL,
  group_id VARCHAR(32) NOT NULL,
  status ENUM('not_reviewed','open','not_a_finding','not_applicable') DEFAULT 'not_reviewed',
  finding_details LONGTEXT,
  comments LONGTEXT,
  overrides JSON,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (scan_id, group_id),
  FOREIGN KEY (scan_id) REFERENCES stig_scan(scan_id) ON DELETE CASCADE
);

CREATE OR REPLACE VIEW v_scan_rules AS
SELECT f.scan_id, r.group_id, r.rule_version, r.severity, r.rule_title,
       r.check_content, r.fix_text, f.status, f.finding_details, f.comments
FROM stig_finding f
JOIN stig_scan s ON s.scan_id=f.scan_id
JOIN stig_rule r ON r.benchmark_id=s.benchmark_id AND r.group_id=f.group_id;
