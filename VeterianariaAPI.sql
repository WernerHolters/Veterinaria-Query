CREATE DATABASE VeterinariaAPI
GO
USE VeterinariaAPI
GO

CREATE TABLE Personas
(
	idPersona	int PRIMARY KEY IDENTITY(1,1),
	CI			varchar(20) NOT NULL,
	Nombre		varchar(50) NOT NULL,
	Telefono	varchar(20) NOT NULL,
);
GO

CREATE TABLE Clientes
(
	idCliente		int PRIMARY KEY IDENTITY(1,1),
	PrimerApellido	varchar(20) NOT NULL,
	CuentaBanco		varchar(30) NOT NULL,
	Direccion		varchar(50) NOT NULL,
	Telefono		varchar(20) NOT NULL
);
GO

CREATE TABLE PersonaCliente
(
	FechaAsociacion	date NOT NULL,
	idPersona		int NOT NULL, --foranea
	idCliente		int NOT NULL, --foranea
	PRIMARY KEY (idPersona, idCliente),
	FOREIGN KEY (idPersona) REFERENCES Personas (idPersona) ON DELETE CASCADE,
	FOREIGN KEY (idCliente) REFERENCES Clientes (idCliente) ON DELETE CASCADE,
);
GO

CREATE TABLE Mascotas
(
	idMascota		int PRIMARY KEY IDENTITY(1,1),
	Nombre			varchar(20)	NOT NULL,
	Especie			varchar(20) NOT NULL,
	Raza			varchar(20) NOT NULL,
	Color			varchar(20) NOT NULL,
	FechaNacimiento	date NOT NULL,
	PesoActual		float NOT NULL,
	idCliente		int NOT NULL, --foranea
	FOREIGN KEY (idCliente) REFERENCES Clientes (idCliente) ON DELETE CASCADE
);
GO

CREATE TABLE Pesos
(
	FechaPeso	date NOT NULL,
	Peso		float NOT NULL,
	idMascota	int NOT NULL, --foranea
	PRIMARY KEY (idMascota, FechaPeso),
	FOREIGN KEY (idMascota) REFERENCES Mascotas (idMascota) ON DELETE CASCADE
);
GO

CREATE TABLE HistorialMedico
(
	FechaEnfermedad	date NOT NULL,
	Enfermedad		varchar(20) NOT NULL,
	idMascota		int NOT NULL, --foranea
	PRIMARY KEY (idMascota, FechaEnfermedad),
	FOREIGN KEY (idMascota) REFERENCES Mascotas (idMascota) ON DELETE CASCADE
);
GO

CREATE TABLE Vacunas
(
	idVacuna			int PRIMARY KEY IDENTITY(1,1),
	Nombre				varchar(20) NOT NULL,
	Laboratorio			varchar(20) NOT NULL,
	EnfermedadPrevenida	varchar(20) NOT NULL,
	Dosis				int NOT NULL,
);
GO

CREATE TABLE MascotaVacuna
(
	FechaVacuna	date NOT NULL,
	idMascota	int NOT NULL, --foranea
	idVacuna	int NOT NULL, --foranea
	PRIMARY KEY (idMascota, idVacuna),
	FOREIGN KEY (idMascota) REFERENCES Mascotas (idMascota) ON DELETE CASCADE,
	FOREIGN KEY (idVacuna) REFERENCES Vacunas (idVacuna) ON DELETE CASCADE
);
GO

CREATE TABLE Huespedes
(
	idHuesped		int PRIMARY KEY IDENTITY(1,1),
	FechaIngreso	date NOT NULL,
	FechaSalida		date NOT NULL,
	CostoHospedaje	money NOT NULL,
	idMascota		int NOT NULL, --foranea
	FOREIGN KEY (idMascota) REFERENCES Mascotas (idMascota) ON DELETE CASCADE
);
GO

CREATE TABLE Servicios
(
	idServicio		int PRIMARY KEY IDENTITY(1,1),
	Descripcion		varchar(50) NOT NULL,
	CostoServicio	money NOT NULL,
);
GO

CREATE TABLE ServicioHuesped
(
	idHuesped	int NOT NULL, --foranea
	idServicio	int NOT NULL, --foranea
	PRIMARY KEY (idHuesped, idServicio),
	FOREIGN KEY (idServicio) REFERENCES Servicios (idServicio) ON DELETE CASCADE,
	FOREIGN KEY (idHuesped) REFERENCES Huespedes (idHuesped) ON DELETE CASCADE,
);
GO
/*========================================= Cliente =====================================================*/
CREATE PROCEDURE SP_CrearCliente
(
    @PrimerApellido	varchar(20),
    @CuentaBanco	varchar(30),
    @Direccion		varchar(50),
    @Telefono		varchar(20)
)
AS
BEGIN
    INSERT INTO Clientes (PrimerApellido, CuentaBanco, Direccion, Telefono)
    VALUES (@PrimerApellido, @CuentaBanco, @Direccion, @Telefono)
END
--EXEC SP_CrearCliente Holters, 20202020, Paragua, 71381523

GO
CREATE PROCEDURE SP_ObtenerCliente
AS
BEGIN
    SELECT * FROM Clientes
END
--EXEC SP_ObtenerCliente 

GO
CREATE PROCEDURE SP_ActualizarCliente
(
    @idCliente int,
    @PrimerApellido varchar(20),
    @CuentaBanco varchar(20),
    @Direccion varchar(50),
    @Telefono varchar(20)
)
AS
BEGIN
    UPDATE Clientes
    SET PrimerApellido = @PrimerApellido,
        CuentaBanco = @CuentaBanco,
        Direccion = @Direccion,
        Telefono = @Telefono
    WHERE idCliente = @idCliente
END
--EXEC SP_ActualizarCliente 11, Holters, 20202020, Paragua, 71381523
GO

CREATE PROCEDURE SP_EliminarCliente
(
    @idCliente int
)
AS
BEGIN
    DELETE FROM Clientes
	WHERE idCliente = @idCliente
END
--EXEC SP_EliminarCliente 11
GO

/*====================================== MASCOTAS ===================================== */

CREATE PROCEDURE SP_CrearMascota
    @Nombre varchar(20),
    @Especie varchar(20),
    @Raza varchar(20),
    @Color varchar(20),
    @FechaNacimiento date,
    @PesoActual float,
    @IdCliente int
AS
BEGIN
    INSERT INTO Mascotas (Nombre, Especie, Raza, Color, FechaNacimiento, PesoActual, idCliente)
    VALUES (@Nombre, @Especie, @Raza, @Color, @FechaNacimiento, @PesoActual, @IdCliente);
END;
--EXEC SP_CrearMascota 'Babu', 'Gato', 'Gato Europeo', 'Siames', '2024-06-08', 5, 3
GO

CREATE PROCEDURE SP_ActualizarMascota
    @IdMascota int,
    @Nombre varchar(20),
    @Especie varchar(20),
    @Raza varchar(20),
    @Color varchar(20),
    @FechaNacimiento date,
    @PesoActual float,
    @IdCliente int
AS
BEGIN
    UPDATE Mascotas
    SET Nombre = @Nombre,
        Especie = @Especie,
        Raza = @Raza,
        Color = @Color,
        FechaNacimiento = @FechaNacimiento,
        PesoActual = @PesoActual,
        idCliente = @IdCliente
    WHERE idMascota = @IdMascota;
END;
GO

CREATE PROCEDURE SP_EliminarMascota
    @IdMascota int
AS
BEGIN
    DELETE FROM Mascotas
    WHERE idMascota = @IdMascota;
END;
GO

CREATE PROCEDURE SP_ObtenerMascota
AS
BEGIN
    SELECT *
    FROM Mascotas
END;
--EXEC SP_ObtenerMascota
GO

/*==================================== Personas =========================================*/

CREATE PROCEDURE SP_CrearPersona
(
    @CI varchar(20),
    @Nombre varchar(50),
    @Telefono varchar(20)
)
AS
BEGIN
    INSERT INTO Personas (CI, Nombre, Telefono)
    VALUES (@CI, @Nombre, @Telefono)
END
GO
--EXEC SP_CrearPersona '555', '8', '5'

CREATE PROCEDURE SP_ObtenerPersona
AS
BEGIN
    SELECT * FROM Personas
END
GO
--EXEC SP_ObtenerPersona

CREATE PROCEDURE SP_EliminarPersona
(
    @idPersona int
)
AS
BEGIN
    DELETE FROM Personas
    WHERE idPersona = @idPersona
END
GO
--EXEC SP_EliminarPersona 1

CREATE PROCEDURE SP_ActualizarPersona
(
    @idPersona int,
    @CI varchar(20),
    @Nombre varchar(50),
    @Telefono varchar(20)
)
AS
BEGIN
    UPDATE Personas
    SET CI = @CI,
        Nombre = @Nombre,
        Telefono = @Telefono
    WHERE idPersona = @idPersona
END
GO 

/*==================================== Huespedes =========================================*/

CREATE PROCEDURE SP_CrearHuesped
(
    @FechaIngreso date,
    @FechaSalida date,
    @CostoHospedaje money,
    @idMascota int
)
AS
BEGIN
    INSERT INTO Huespedes (FechaIngreso, FechaSalida, CostoHospedaje, idMascota)
    VALUES (@FechaIngreso, @FechaSalida, @CostoHospedaje, @idMascota)
END
GO

CREATE PROCEDURE SP_ObtenerHuesped
AS
BEGIN
    SELECT * FROM Huespedes
END
GO

CREATE PROCEDURE SP_ActualizarHuesped
(
    @idHuesped int,
    @FechaIngreso date,
    @FechaSalida date,
    @CostoHospedaje money,
    @idMascota int
)
AS
BEGIN
    UPDATE Huespedes
    SET FechaIngreso = @FechaIngreso,
        FechaSalida = @FechaSalida,
        CostoHospedaje = @CostoHospedaje,
        idMascota = @idMascota
    WHERE idHuesped = @idHuesped
END
GO

CREATE PROCEDURE SP_EliminarHuesped
(
    @idHuesped int
)
AS
BEGIN
    DELETE FROM Huespedes
    WHERE idHuesped = @idHuesped
END
GO

/*==================== EXTRAS ======================== */

CREATE PROCEDURE SP_ObtenerClienteMascota
    @IdMascota INT
AS
BEGIN
    SELECT Clientes.PrimerApellido
    FROM Clientes
    INNER JOIN Mascotas ON Mascotas.idCliente = Clientes.idCliente
    WHERE idMascota = @IdMascota;
END;
GO

CREATE PROCEDURE SP_AsociarPersonaCliente
(
    @FechaAsociacion date,
    @idPersona int,
    @idCliente int
)
AS
BEGIN
    INSERT INTO PersonaCliente (FechaAsociacion, idPersona, idCliente)
    VALUES (@FechaAsociacion, @idPersona, @idCliente)
END
EXEC SP_AsociarPersonaCliente '2002-05-21', 3, 4
--INSERT INTO PersonaCliente (FechaAsociacion, idCliente, idPersona) VALUES ('2024-10-06', 3, 2)
GO

/*==================================== ReporteHuespedesPorFechas =========================================*/
CREATE PROCEDURE ReporteHuespedesPorFechas
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    -- Declarar variables para conteo
    DECLARE @HuespedCount INT;

    -- Contar huéspedes en el período especificado
    SELECT @HuespedCount = COUNT(*)
    FROM Huespedes
    WHERE FechaIngreso BETWEEN @FechaInicio AND @FechaFin OR FechaSalida BETWEEN @FechaInicio AND @FechaFin OR (FechaIngreso <= @FechaFin AND FechaSalida IS NULL);

    -- Verificar que haya al menos un huésped en el período especificado
    IF @HuespedCount = 0
    BEGIN
        PRINT 'No hay huéspedes en el período especificado.';
        RETURN;
    END

    -- Si hay al menos un huésped, ejecutar el reporte
    SELECT
        Huespedes.idHuesped,
        Huespedes.FechaIngreso,
        Huespedes.FechaSalida,
        Huespedes.CostoHospedaje,
        Clientes.PrimerApellido AS ApellidoFamilia,
        Personas.Nombre AS NombrePersona,
        Mascotas.Nombre AS NombreMascota,
        CAST(Huespedes.CostoHospedaje AS DECIMAL(18,2)) + ISNULL(SUM(CAST(Servicios.CostoServicio AS DECIMAL(18,2))), 0) AS costo_total
    FROM
        Huespedes
    LEFT JOIN
        Mascotas ON Huespedes.idMascota = Mascotas.idMascota
    LEFT JOIN
        Clientes ON Mascotas.idCliente = Clientes.idCliente
    LEFT JOIN
        PersonaCliente ON Clientes.idCliente = PersonaCliente.idCliente
    LEFT JOIN
        Personas ON PersonaCliente.idPersona = Personas.idPersona
    LEFT JOIN
        ServicioHuesped ON Huespedes.idHuesped = ServicioHuesped.idHuesped
    LEFT JOIN
        Servicios ON ServicioHuesped.idServicio = Servicios.idServicio
    WHERE
        (Huespedes.FechaIngreso BETWEEN @FechaInicio AND @FechaFin OR
         Huespedes.FechaSalida BETWEEN @FechaInicio AND @FechaFin OR
         (Huespedes.FechaIngreso <= @FechaFin AND Huespedes.FechaSalida IS NULL))
    GROUP BY
        Huespedes.idHuesped,
        Huespedes.FechaIngreso,
        Huespedes.FechaSalida,
        Huespedes.CostoHospedaje,
        Clientes.PrimerApellido,
        Personas.Nombre,
        Mascotas.Nombre;
END;
EXEC ReporteHuespedesPorFechas '2022-01-01', '2025-01-07';
GO

/*==================================== RegistrarHuesped =========================================*/
CREATE PROCEDURE RegistrarHuesped
    @NombreMascota VARCHAR(20),
    @FechaIngreso DATE,
    @FechaSalida DATE,
    @CostoHospedaje DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @idMascota INT;

    -- Verificar si la mascota ya está registrada
    SELECT @idMascota = idMascota
    FROM Mascotas
    WHERE Nombre = @NombreMascota;

    -- Si la mascota no está registrada, lanzar un error
    IF @idMascota IS NULL
    BEGIN
        RAISERROR ('La mascota no está registrada. Por favor, registre la mascota antes de proceder.', 16, 1);
        RETURN;
    END;

    -- Verificar si la mascota ya está registrada como huésped
    IF EXISTS (SELECT 1 FROM Huespedes WHERE idMascota = @idMascota)
    BEGIN
        RAISERROR ('La mascota ya está registrada como huésped.', 16, 1);
        RETURN;
    END;

    -- Insertar en la tabla Huespedes
    INSERT INTO Huespedes (FechaIngreso, FechaSalida, CostoHospedaje, idMascota)
    VALUES (@FechaIngreso, @FechaSalida, @CostoHospedaje, @idMascota);
END;
GO
EXEC RegistrarHuesped 
    @NombreMascota = 'Babu',
    @FechaIngreso = '2024-06-01',
    @FechaSalida = '2024-06-07',
    @CostoHospedaje = 200.00;
GO

/*==================================== CheckoutHuesped =========================================*/
CREATE PROCEDURE CheckoutHuesped
    @CodHuesped CHAR(10)
AS
BEGIN
    DECLARE @CostoHospedaje DECIMAL(18,2);
    DECLARE @CostoServicios DECIMAL(18,2);
    DECLARE @CostoTotal DECIMAL(18,2);

    -- Obtener el costo de hospedaje
    SELECT @CostoHospedaje = CostoHospedaje
    FROM Huespedes
    WHERE idHuesped = @CodHuesped;

    -- Calcular el costo de los servicios adicionales
    SELECT @CostoServicios = SUM(CostoServicio)
    FROM Servicios
    INNER JOIN ServicioHuesped ON Servicios.idServicio = ServicioHuesped.idServicio
    WHERE ServicioHuesped.idHuesped = @CodHuesped;

    -- Calcular el costo total
    SET @CostoTotal = ISNULL(@CostoHospedaje, 0) + ISNULL(@CostoServicios, 0);

    -- Emisión de la nota de cobranza
    SELECT
        Huespedes.idHuesped,
        Clientes.PrimerApellido AS ApellidoFamilia,
        Personas.Nombre AS NombrePersona,
        Mascotas.Nombre AS NombreMascota,
        Huespedes.FechaIngreso,
        Huespedes.FechaSalida,
        @CostoHospedaje AS CostoHospedaje,
        ISNULL(@CostoServicios, 0) AS CostoServiciosAdicionales,
        @CostoTotal AS CostoTotal
    FROM
        Huespedes
    LEFT JOIN
        Mascotas ON Huespedes.idMascota = Mascotas.idMascota
    LEFT JOIN
        Clientes ON Mascotas.idCliente = Clientes.idCliente
    LEFT JOIN
        PersonaCliente ON Clientes.idCliente = PersonaCliente.idCliente
    LEFT JOIN
        Personas ON PersonaCliente.idPersona = Personas.idPersona
    WHERE
        Huespedes.idHuesped = @CodHuesped;
END;

EXEC CheckoutHuesped @CodHuesped = '2';
GO