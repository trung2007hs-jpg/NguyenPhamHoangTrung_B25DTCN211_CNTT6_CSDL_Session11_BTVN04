DROP PROCEDURE IF EXISTS GetPatientDebt;
DELIMITER $$
CREATE PROCEDURE GetPatientDebt(
    IN p_patient_id INT,
    IN p_phone VARCHAR(20),
    OUT o_total_debt DECIMAL(10,2),
    OUT o_message VARCHAR(255)
)
BEGIN
    IF p_patient_id IS NULL AND p_phone IS NULL THEN
        SET o_total_debt = 0;
        SET o_message = 'Vui làng nhập ID hoặc SĐT';
    ELSE
        SELECT IFNULL(total_debt,0)
        INTO o_total_debt
        FROM Patients
        WHERE patient_id = p_patient_id
           OR phone = p_phone
        LIMIT 1;
        IF o_total_debt = 0 THEN
            SET o_message = 'Không tìm thấy';
        ELSE
            SET o_message = 'Tra cứu thành công';
        END IF;
    END IF;
END $$

-- CALL test
-- 1. Chỉ ID
CALL GetPatientDebt(1,NULL,@debt,@msg);
SELECT @debt,@msg;

-- 2. Chỉ Phone
CALL GetPatientDebt(NULL,'0901234567',@debt,@msg);
SELECT @debt,@msg;

-- 3. NULL cả 2
CALL GetPatientDebt(NULL,NULL,@debt,@msg);
SELECT @debt,@msg;

-- 4. Không tồn tại
CALL GetPatientDebt(999,NULL,@debt,@msg);
SELECT @debt,@msg;