-- Create a log table
CREATE TABLE log (
  id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT NOT ENFORCED,
  log_message TEXT,
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the readings_2024_06 table
CREATE TABLE rj_cetrio_desafio_readings_2024_06 (
  datahora TIMESTAMP NOT NULL,
  placa TEXT NOT NULL,
  Velocity FLOAT NOT NULL,
  camera_longitude FLOAT NOT NULL,
  camera_latitude FLOAT NOT NULL,
  PRIMARY KEY (datahora, placa)
);

-- Function to check for duplicates
CREATE FUNCTION check_for_duplicates(new_placa TEXT, new_datahora TIMESTAMP, new_camera_longitude FLOAT, new_camera_latitude FLOAT) RETURNS INTEGER
BEGIN
  DECLARE duplicate_count INTEGER;
  
  SELECT COUNT(*)
  INTO duplicate_count
  FROM rj_cetrio_desafio_readings_2024_06
  WHERE placa = new_placa
    AND datahora = new_datahora
    AND (camera_longitude != new_camera_longitude OR camera_latitude != new_camera_latitude);

  IF duplicate_count > 0 THEN
    INSERT INTO log (log_message)
    VALUES (Duplicate placa found:  || new_placa ||  at different locations at the same time.);
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END;


  
  SET is_duplicate := check_for_duplicates(placa_val, datahora_val, camera_longitude_val, camera_latitude_val);
  
  IF is_duplicate = 0 THEN
    INSERT INTO rj_cetrio_desafio_readings_2024_06 (datahora, placa, Velocity, camera_longitude, camera_latitude)
    VALUES (datahora_val, placa_val, 16.0, camera_longitude_val, camera_latitude_val);
  END IF;
END;

-- Check the log table to see if the entry was logged
SELECT * FROM log;