class FileValidationError(Exception):
    """Exception raised when data file violates some validation criteria.

    Parameters:
        source     - Where the violation occured
        validation - Validation check
        message    - Message to return
    """

    def __init__(self, source, validation, message="Data file is invalid"):
        self.source = source
        self.validation = validation
        self.message = message
        super().__init__(self.message)

    def __str__(self):
        return(f"Source: {self.source}, Validation: {self.validation}")
        