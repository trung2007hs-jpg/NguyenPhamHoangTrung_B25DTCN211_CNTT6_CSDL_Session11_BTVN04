DROP PROCEDURE IF EXISTS GetPatientDebt;
DELIMITER $$

CREATE PROCEDURE GetPatientDebt(
    IN p_patient_id INT,
    IN p_phone VARCHAR(20),
    OUT o_total_debt DECIMAL(10,2),
    OUT o_message VARCHAR(255)
)
BEGIN
    -- Khởi tạo giá trị mặc định
    SET o_total_debt = 0;
    -- Kịch bản 1: Tiếp tân lười biếng
    IF p_patient_id IS NULL AND p_phone IS NULL THEN
        SET o_message = 'Vui lòng nhập ID hoặc Số điện thoại để tra cứu!';
    ELSE
        -- Dùng biến tạm để kiểm tra sự tồn tại
        SET o_total_debt = NULL;
        IF p_patient_id IS NOT NULL THEN
            SELECT total_debt INTO o_total_debt FROM Patients WHERE patient_id = p_patient_id LIMIT 1;
        END IF;
        -- Nếu tìm theo ID không ra hoặc không có ID, thì tìm theo Phone
        IF o_total_debt IS NULL AND p_phone IS NOT NULL THEN
            SELECT total_debt INTO o_total_debt FROM Patients WHERE phone = p_phone LIMIT 1;
        END IF;
        -- Kịch bản 2: Xử lý kết quả trả về
        IF o_total_debt IS NULL THEN
            SET o_total_debt = 0;
            SET o_message = 'Không tìm thấy bệnh nhân trong hệ thống.';
        ELSE
            SET o_message = 'Tra cứu thành công!';
        END IF;
    END IF;
END $$
DELIMITER ;

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
