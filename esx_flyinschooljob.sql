

INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_flying','flying',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_flying','flying',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('flying','Letecky Urad')
;

INSERT INTO `licenses` (type, label) VALUES
  ('letecky1','Letecky preukaz PPLA')
  ('letecky2','Letecky preukaz CPLA')
  ('letecky3','Letecky preukaz CPLH')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('flying',0,'airman','Pilot',150,'{}','{}'),
  ('flying',1,'senior','Skuseny Pilot',200,'{}','{}'),
  ('flying',2,'staff','Manager',250,'{}','{}'),
  ('flying',3,'chief','Zastupca',300,'{}','{}'),
  ('flying',4,'boss','Riaditel',350,'{}','{}')
;
