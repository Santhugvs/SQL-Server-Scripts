CREATE PROCEDURE InsertNewInsurancePolicy
    @PolicyHolderName VARCHAR(100),
    @PolicyType VARCHAR(50),
    @PremiumAmount DECIMAL(10, 2),
    @PolicyStartDate DATE,
    @PolicyEndDate DATE,
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 1: Check for duplicate active policy
        IF EXISTS (
            SELECT 1 FROM InsurancePolicy
            WHERE PolicyHolderName = @PolicyHolderName
              AND PolicyType = @PolicyType
              AND Status = 'Active'
              AND (
                  (@PolicyStartDate BETWEEN PolicyStartDate AND PolicyEndDate)
                  OR
                  (@PolicyEndDate BETWEEN PolicyStartDate AND PolicyEndDate)
              )
        )
        BEGIN
            THROW 50001, 'Duplicate active policy with overlapping dates found.', 1;
        END

        -- Step 2: Insert new policy
        INSERT INTO InsurancePolicy
        (PolicyHolderName, PolicyType, PremiumAmount, PolicyStartDate, PolicyEndDate, Status)
        VALUES
        (@PolicyHolderName, @PolicyType, @PremiumAmount, @PolicyStartDate, @PolicyEndDate, @Status);

        -- Step 3: Commit if everything is fine
        COMMIT TRANSACTION;
        PRINT 'Policy inserted successfully.';
    END TRY

    BEGIN CATCH
        -- Rollback in case of error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Log the error
        INSERT INTO ErrorLog (ProcedureName, ErrorMessage)
        VALUES (OBJECT_NAME(@@PROCID), ERROR_MESSAGE());

        -- Optional: Re-raise error for application
        RAISERROR('Error', 16, 1);
    END CATCH
END;
