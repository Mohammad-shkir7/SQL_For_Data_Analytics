--DROP TABLE testtable ;
DROP  TABLE IF EXISTS testTable;
CREATE TABLE testtable (
person_serial serial NOT NULL
,person_first_name varchar(50) NOT null
,person_last_name varchar(50) NOT NULL
,person_id_number varchar(10) NOT NULL CHECK (length(person_id_number)>3) 
,person_gender char(1) 
,person_address varchar(80) NOT NULL DEFAULT 'N/A'
,is_active boolean DEFAULT TRUE 

,CONSTRAINT 
	"primary" PRIMARY KEY (person_serial),
	UNIQUE (person_id_number)
	)
;

-- This function transforms the given parameter into upper case
CREATE OR REPLACE FUNCTION uppercase_gender_on_insert() RETURNS trigger AS $uppercase_gender_on_insert$
    BEGIN        
        NEW.person_gender = upper(NEW.person_gender);
        RETURN NEW;
    END;
$uppercase_gender_on_insert$ LANGUAGE plpgsql;

-- This triger transforms the char value of person_gender to upper case using the previous function
CREATE TRIGGER uppercase_gender_on_insert BEFORE INSERT OR UPDATE ON testtable
    FOR EACH ROW EXECUTE PROCEDURE uppercase_gender_on_insert();
   
-- creats a unique relation between personal_serial and person_id_number 
-- in order to use later for 'on conflict'
CREATE UNIQUE INDEX uniq_idx_serial_id
  ON testtable(person_serial, person_id_number) 
;

