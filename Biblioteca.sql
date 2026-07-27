--CREAR TABLAS--
--El orden al crear las tablas importa, creenlas de una en una y en orden.--
--1.Tabla CATEGORIA.
CREATE TABLE CATEGORIA (
    ID_CATEGORIA INT PRIMARY KEY,
    NOMBRE VARCHAR2(100) NOT NULL,
    DESCRIPCION VARCHAR2(255));

--2.Tabla AUTOR.
CREATE TABLE AUTOR (
    ID_AUTOR INT PRIMARY KEY,
    NOMBRE VARCHAR2(150) NOT NULL);

--3.Tabla USUARIOS.
CREATE TABLE USUARIOS (
    CEDULA VARCHAR2(20) PRIMARY KEY,
    NOMBRE VARCHAR2(150) NOT NULL,
    TELEFONO VARCHAR2(15),
    CORREO_ELECTRONICO VARCHAR2(100),
    ESTATUS VARCHAR2(20) CHECK (ESTATUS IN ('Activo', 'Inactivo', 'Sancionado')));

--4.Tabla LIBROS.
CREATE TABLE LIBROS (
    ID_LIBRO INT PRIMARY KEY,
    ID_CATEGORIA INT NOT NULL,
    ID_AUTOR INT NOT NULL,
    TITULO VARCHAR2(200) NOT NULL,
    CONSTRAINT FK_LIBRO_CAT FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIA(ID_CATEGORIA),
    CONSTRAINT FK_LIBRO_AUT FOREIGN KEY (ID_AUTOR) REFERENCES AUTOR(ID_AUTOR));

--5.Tabla EJEMPLARES.
CREATE TABLE EJEMPLARES (
    ID_EJEMPLAR INT PRIMARY KEY,
    ID_LIBRO INT NOT NULL,
    ESTADO_CONSERVACION VARCHAR2(50) CHECK (ESTADO_CONSERVACION IN ('Bueno', 'Regular', 'Dañado')),
    DISPONIBLE CHAR(1) CHECK (DISPONIBLE IN ('S', 'N')),
    CONSTRAINT FK_EJEMPLAR_LIBRO FOREIGN KEY (ID_LIBRO) REFERENCES LIBROS(ID_LIBRO));

--6.Tabla PRESTAMOS.
CREATE TABLE PRESTAMOS (
    ID_PRESTAMO INT PRIMARY KEY,
    CEDULA VARCHAR2(20) NOT NULL,
    ID_EJEMPLAR INT NOT NULL,
    FECHA_PRESTAMO DATE NOT NULL,
    FECHA_DEVOLUCION DATE,
    ESTADO VARCHAR2(20) CHECK (ESTADO IN ('Activo', 'Devuelto', 'Vencido')),
    CONSTRAINT FK_PRESTAMO_US FOREIGN KEY (CEDULA) REFERENCES USUARIOS(CEDULA),
    CONSTRAINT FK_PRESTAMO_EJ FOREIGN KEY (ID_EJEMPLAR) REFERENCES EJEMPLARES(ID_EJEMPLAR));

--7.Tabla DEVOLUCIONES.
CREATE TABLE DEVOLUCIONES (
    ID_DEVOLUCION INT PRIMARY KEY,
    ID_PRESTAMO INT NOT NULL,
    FECHA_RECEPCION DATE NOT NULL,
    DIAS_RETRASO INT DEFAULT 0,
    PENALIZACION NUMBER(10,2) DEFAULT 0.00,
    CONSTRAINT FK_DEV_PRESTAMO FOREIGN KEY (ID_PRESTAMO) REFERENCES PRESTAMOS(ID_PRESTAMO));

--INSERTAR EN TABLAS--
--1.Insertar CATEGORIAS.
INSERT INTO CATEGORIA (ID_CATEGORIA, NOMBRE, DESCRIPCION) 
VALUES (1, 'Ficción', 'Literatura de ficción, novela y narrativa');
INSERT INTO CATEGORIA (ID_CATEGORIA, NOMBRE, DESCRIPCION) 
VALUES (2, 'Ciencia', 'Libros de divulgación científica y astronomía');

--2.Insertar AUTORES.
INSERT INTO AUTOR (ID_AUTOR, NOMBRE) 
VALUES (1, 'Gabriel García Márquez');
INSERT INTO AUTOR (ID_AUTOR, NOMBRE) 
VALUES (2, 'Carl Sagan');

--3.Insertar USUARIOS.
INSERT INTO USUARIOS (CEDULA, NOMBRE, TELEFONO, CORREO_ELECTRONICO, ESTATUS) 
VALUES ('0912345678', 'Juan Perez', '0991234567', 'juan@email.com', 'Activo');
INSERT INTO USUARIOS (CEDULA, NOMBRE, TELEFONO, CORREO_ELECTRONICO, ESTATUS) 
VALUES ('0987654321', 'Maria Gomez', '0981112233', 'maria@email.com', 'Activo');

--4.Insertar LIBROS.
INSERT INTO LIBROS (ID_LIBRO, ID_CATEGORIA, ID_AUTOR, TITULO) 
VALUES (10, 1, 1, 'Cien años de soledad');
INSERT INTO LIBROS (ID_LIBRO, ID_CATEGORIA, ID_AUTOR, TITULO) 
VALUES (20, 2, 2, 'Cosmos');

--5.Insertar EJEMPLARES.
--Tres copias de "Cien años de soledad". Una de ellas no disponible por daño.
INSERT INTO EJEMPLARES (ID_EJEMPLAR, ID_LIBRO, ESTADO_CONSERVACION, DISPONIBLE) 
VALUES (101, 10, 'Bueno', 'S');
INSERT INTO EJEMPLARES (ID_EJEMPLAR, ID_LIBRO, ESTADO_CONSERVACION, DISPONIBLE) 
VALUES (102, 10, 'Regular', 'S');
INSERT INTO EJEMPLARES (ID_EJEMPLAR, ID_LIBRO, ESTADO_CONSERVACION, DISPONIBLE) 
VALUES (103, 10, 'Dañado', 'N'); 
--Dos copias de "Cosmos". Ambas disponibles.
INSERT INTO EJEMPLARES (ID_EJEMPLAR, ID_LIBRO, ESTADO_CONSERVACION, DISPONIBLE) 
VALUES (201, 20, 'Bueno', 'S');
INSERT INTO EJEMPLARES (ID_EJEMPLAR, ID_LIBRO, ESTADO_CONSERVACION, DISPONIBLE) 
VALUES (202, 20, 'Bueno', 'S');

--6.Insertar PRESTAMOS
--Datos de prueba añadidos manualmente. Los datos para PRESTAMOS y DEVOLUCIONES 
--deberían ser añadidos con los Triggers.
INSERT INTO PRESTAMOS (ID_PRESTAMO, CEDULA, ID_EJEMPLAR, FECHA_PRESTAMO, FECHA_DEVOLUCION, ESTADO) 
VALUES (1, '0912345678', 101, SYSDATE - 5, SYSDATE + 2, 'Activo');
INSERT INTO PRESTAMOS (ID_PRESTAMO, CEDULA, ID_EJEMPLAR, FECHA_PRESTAMO, FECHA_DEVOLUCION, ESTADO) 
VALUES (2, '0912345678', 201, SYSDATE - 10, SYSDATE - 3, 'Devuelto');
INSERT INTO PRESTAMOS (ID_PRESTAMO, CEDULA, ID_EJEMPLAR, FECHA_PRESTAMO, FECHA_DEVOLUCION, ESTADO) 
VALUES (3, '0987654321', 102, SYSDATE - 15, SYSDATE - 5, 'Vencido');

--7. Insertar DEVOLUCIONES
--Datos de prueba añadidos manualmente. Los datos para PRESTAMOS y DEVOLUCIONES 
--deberían ser añadidos con los Triggers.
INSERT INTO DEVOLUCIONES (ID_DEVOLUCION, ID_PRESTAMO, FECHA_RECEPCION, DIAS_RETRASO, PENALIZACION) 
VALUES (1, 2, SYSDATE, 3, 1.50);
INSERT INTO DEVOLUCIONES (ID_DEVOLUCION, ID_PRESTAMO, FECHA_RECEPCION, DIAS_RETRASO, PENALIZACION) 
VALUES (2, 3, SYSDATE - 5, 0, 0.00);

--SELECTS PARA PROBAR LAS TABLAS--
SELECT * FROM AUTOR;
SELECT * FROM CATEGORIA;
SELECT * FROM EJEMPLARES;
SELECT * FROM LIBROS;
SELECT * FROM USUARIOS;
SELECT * FROM PRESTAMOS;
SELECT * FROM DEVOLUCIONES;

--CREAR FUNCIONES--
--1.Funcion FN_CANTIDAD_DISPONIBLE.
CREATE OR REPLACE FUNCTION FN_CANTIDAD_DISPONIBLE (
    p_id_libro IN INT
) RETURN INT 
IS
    v_total_disponibles INT;
BEGIN
    SELECT COUNT(*)
    INTO v_total_disponibles
    FROM EJEMPLARES
    WHERE ID_LIBRO = p_id_libro 
      AND DISPONIBLE = 'S';
    RETURN v_total_disponibles;
END;
/
--Prueba:
SELECT 
    ID_LIBRO,
    TITULO, 
    FN_CANTIDAD_DISPONIBLE(ID_LIBRO) AS EJEMPLARES_LISTOS_PARA_PRESTAR
FROM LIBROS;

--2.Funcion FN_DISPONIBILIDAD_LIBRO.
CREATE OR REPLACE FUNCTION FN_DISPONIBILIDAD_LIBRO (
    p_id_libro IN INT
) RETURN VARCHAR2
IS
    v_cantidad INT;
BEGIN
    v_cantidad := FN_CANTIDAD_DISPONIBLE(p_id_libro);
    IF v_cantidad > 0 THEN
        RETURN 'SÍ';
    ELSE
        RETURN 'NO';
    END IF;
END;
/
--Prueba:
SELECT 
    ID_LIBRO,
    TITULO, 
    FN_DISPONIBILIDAD_LIBRO(ID_LIBRO) AS DISPONIBLE_PARA_PRESTAMO
FROM LIBROS;

--3.Funcion FN_PRESTAMOS_ACTIVOS_USER.
CREATE OR REPLACE FUNCTION FN_PRESTAMOS_ACTIVOS_USER (
    p_cedula IN VARCHAR2
) RETURN VARCHAR2
IS
    v_estado_resumen VARCHAR2(100);
    v_cant_activos INT;
    v_cant_vencidos INT;
BEGIN
    SELECT COUNT(*) INTO v_cant_activos
    FROM PRESTAMOS
    WHERE CEDULA = p_cedula AND ESTADO = 'Activo';
    SELECT COUNT(*) INTO v_cant_vencidos
    FROM PRESTAMOS
    WHERE CEDULA = p_cedula AND ESTADO = 'Vencido';
    IF v_cant_vencidos > 0 THEN
        v_estado_resumen := 'BLOQUEADO: Tiene ' || v_cant_vencidos || ' préstamo(s) VENCIDO(S)';
    ELSIF v_cant_activos > 0 THEN
        v_estado_resumen := 'AL DÍA: Tiene ' || v_cant_activos || ' préstamo(s) activo(s)';
    ELSE
        v_estado_resumen := 'SIN PRÉSTAMOS PENDIENTES';
    END IF;

    RETURN v_estado_resumen;
END;
/
--Prueba:
SELECT 
    CEDULA,
    NOMBRE,
    FN_PRESTAMOS_ACTIVOS_USER(CEDULA) AS ESTADO_CUENTA
FROM USUARIOS;

--4.Funcion FN_CALCULAR_PENALIZACION.
CREATE OR REPLACE FUNCTION FN_CALCULAR_PENALIZACION (
    p_id_prestamo IN INT
) RETURN NUMBER
IS
    v_fecha_devolucion DATE;
    v_estado VARCHAR2(20);
    v_dias_retraso INT := 0;
    v_multa NUMBER(10,2) := 0.00;
    v_tarifa_diaria NUMBER(10,2) := 0.50;
BEGIN
    SELECT FECHA_DEVOLUCION, ESTADO
    INTO v_fecha_devolucion, v_estado
    FROM PRESTAMOS
    WHERE ID_PRESTAMO = p_id_prestamo;
    IF v_estado IN ('Vencido', 'Activo') AND SYSDATE > v_fecha_devolucion THEN
        v_dias_retraso := TRUNC(SYSDATE - v_fecha_devolucion);
        v_multa := v_dias_retraso * v_tarifa_diaria;
    END IF;
    RETURN v_multa;
END;
/
--Prueba:
SELECT 
    ID_PRESTAMO,
    CEDULA,
    ESTADO,
    FECHA_DEVOLUCION,
    FN_CALCULAR_PENALIZACION(ID_PRESTAMO) AS MULTA_ESTIMADA_USD
FROM PRESTAMOS;


--Integrante 2-- 
--Corregir préstamos que ya tienen una devolución registrada.
UPDATE PRESTAMOS P
SET P.ESTADO = 'Devuelto'
WHERE EXISTS (
    SELECT 1
    FROM DEVOLUCIONES D
    WHERE D.ID_PRESTAMO = P.ID_PRESTAMO
);

--Actualizar préstamos activos cuya fecha límite ya pasó.
UPDATE PRESTAMOS
SET ESTADO = 'Vencido'
WHERE ESTADO = 'Activo'
  AND TRUNC(SYSDATE) > TRUNC(FECHA_DEVOLUCION);

--Sincronizar la disponibilidad de los ejemplares.
UPDATE EJEMPLARES E
SET E.DISPONIBLE =
    CASE
        WHEN E.ESTADO_CONSERVACION = 'Dañado' THEN 'N'
        WHEN EXISTS (
            SELECT 1
            FROM PRESTAMOS P
            WHERE P.ID_EJEMPLAR = E.ID_EJEMPLAR
              AND P.ESTADO IN ('Activo', 'Vencido')
        ) THEN 'N'
        ELSE 'S'
    END;

COMMIT;

--2. Crear tabla de historial--
CREATE TABLE HISTORIAL_MOVIMIENTOS (
    ID_HISTORIAL INT PRIMARY KEY,
    ID_PRESTAMO INT,
    CEDULA VARCHAR2(20),
    ID_EJEMPLAR INT,
    TIPO_MOVIMIENTO VARCHAR2(30) NOT NULL,
    FECHA_MOVIMIENTO DATE DEFAULT SYSDATE NOT NULL,
    DESCRIPCION VARCHAR2(500),

    CONSTRAINT CK_HISTORIAL_TIPO CHECK (
        TIPO_MOVIMIENTO IN (
            'PRESTAMO',
            'RENOVACION',
            'DEVOLUCION'
        )
    ),

    CONSTRAINT FK_HIST_PRESTAMO
        FOREIGN KEY (ID_PRESTAMO)
        REFERENCES PRESTAMOS(ID_PRESTAMO),

    CONSTRAINT FK_HIST_USUARIO
        FOREIGN KEY (CEDULA)
        REFERENCES USUARIOS(CEDULA),

    CONSTRAINT FK_HIST_EJEMPLAR
        FOREIGN KEY (ID_EJEMPLAR)
        REFERENCES EJEMPLARES(ID_EJEMPLAR)
);


--Evitar dos devoluciones para el mismo préstamo--
ALTER TABLE DEVOLUCIONES
ADD CONSTRAINT UK_DEVOLUCION_PRESTAMO
UNIQUE (ID_PRESTAMO);

--3.Crear secuencias--
CREATE SEQUENCE SEQ_PRESTAMOS
START WITH 1000
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE SEQ_DEVOLUCIONES
START WITH 1000
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE SEQ_HISTORIAL
START WITH 1000
INCREMENT BY 1
NOCACHE
NOCYCLE;

--4. Trigger para validar un préstamo--
CREATE OR REPLACE TRIGGER TRG_VALIDAR_PRESTAMO
BEFORE INSERT ON PRESTAMOS
FOR EACH ROW
DECLARE
    v_estatus_usuario USUARIOS.ESTATUS%TYPE;
    v_disponible EJEMPLARES.DISPONIBLE%TYPE;
    v_estado_conservacion EJEMPLARES.ESTADO_CONSERVACION%TYPE;
BEGIN
    --Validar la existencia y el estado del usuario.
    BEGIN
        SELECT ESTATUS
        INTO v_estatus_usuario
        FROM USUARIOS
        WHERE CEDULA = :NEW.CEDULA;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20001,
                'El usuario indicado no existe.'
            );
    END;

    IF v_estatus_usuario <> 'Activo' THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'El usuario no se encuentra activo.'
        );
    END IF;

    --Validar la existencia y disponibilidad del ejemplar.
    BEGIN
        SELECT DISPONIBLE, ESTADO_CONSERVACION
        INTO v_disponible, v_estado_conservacion
        FROM EJEMPLARES
        WHERE ID_EJEMPLAR = :NEW.ID_EJEMPLAR
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20003,
                'El ejemplar indicado no existe.'
            );
    END;

    IF v_disponible <> 'S' THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'El ejemplar seleccionado no está disponible.'
        );
    END IF;

    IF v_estado_conservacion = 'Dañado' THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'No se puede prestar un ejemplar dañado.'
        );
    END IF;

    --Asignar valores predeterminados.
    IF :NEW.FECHA_PRESTAMO IS NULL THEN
        :NEW.FECHA_PRESTAMO := SYSDATE;
    END IF;

    IF :NEW.FECHA_DEVOLUCION IS NULL THEN
        :NEW.FECHA_DEVOLUCION := SYSDATE + 7;
    END IF;

    IF :NEW.ESTADO IS NULL THEN
        :NEW.ESTADO := 'Activo';
    END IF;

    IF :NEW.FECHA_DEVOLUCION <= :NEW.FECHA_PRESTAMO THEN
        RAISE_APPLICATION_ERROR(
            -20006,
            'La fecha de devolución debe ser posterior a la fecha del préstamo.'
        );
    END IF;

    IF :NEW.ESTADO <> 'Activo' THEN
        RAISE_APPLICATION_ERROR(
            -20007,
            'Un préstamo nuevo debe registrarse con estado Activo.'
        );
    END IF;
END;
/


--5. Trigger para procesar el préstamo--
CREATE OR REPLACE TRIGGER TRG_PROCESAR_PRESTAMO
AFTER INSERT ON PRESTAMOS
FOR EACH ROW
BEGIN
    UPDATE EJEMPLARES
    SET DISPONIBLE = 'N'
    WHERE ID_EJEMPLAR = :NEW.ID_EJEMPLAR;

    INSERT INTO HISTORIAL_MOVIMIENTOS (
        ID_HISTORIAL,
        ID_PRESTAMO,
        CEDULA,
        ID_EJEMPLAR,
        TIPO_MOVIMIENTO,
        FECHA_MOVIMIENTO,
        DESCRIPCION
    )
    VALUES (
        SEQ_HISTORIAL.NEXTVAL,
        :NEW.ID_PRESTAMO,
        :NEW.CEDULA,
        :NEW.ID_EJEMPLAR,
        'PRESTAMO',
        SYSDATE,
        'Préstamo registrado. Fecha límite: ' ||
        TO_CHAR(:NEW.FECHA_DEVOLUCION, 'DD/MM/YYYY')
    );
END;
/

--6. Trigger para calcular la multa--
CREATE OR REPLACE TRIGGER TRG_CALCULAR_MULTA
BEFORE INSERT OR UPDATE OF FECHA_RECEPCION
ON DEVOLUCIONES
FOR EACH ROW
DECLARE
    v_fecha_limite PRESTAMOS.FECHA_DEVOLUCION%TYPE;
    v_estado PRESTAMOS.ESTADO%TYPE;
BEGIN
    BEGIN
        SELECT FECHA_DEVOLUCION, ESTADO
        INTO v_fecha_limite, v_estado
        FROM PRESTAMOS
        WHERE ID_PRESTAMO = :NEW.ID_PRESTAMO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20020,
                'El préstamo indicado no existe.'
            );
    END;

    IF v_estado = 'Devuelto' THEN
        RAISE_APPLICATION_ERROR(
            -20021,
            'El préstamo ya fue devuelto anteriormente.'
        );
    END IF;

    IF :NEW.FECHA_RECEPCION IS NULL THEN
        :NEW.FECHA_RECEPCION := SYSDATE;
    END IF;

    :NEW.DIAS_RETRASO :=
        GREATEST(
            TRUNC(:NEW.FECHA_RECEPCION) - TRUNC(v_fecha_limite),
            0
        );

    :NEW.PENALIZACION := :NEW.DIAS_RETRASO * 0.50;
END;
/


--7. Trigger para procesar la devolución--
CREATE OR REPLACE TRIGGER TRG_PROCESAR_DEVOLUCION
AFTER INSERT ON DEVOLUCIONES
FOR EACH ROW
DECLARE
    v_id_ejemplar PRESTAMOS.ID_EJEMPLAR%TYPE;
    v_cedula PRESTAMOS.CEDULA%TYPE;
BEGIN
    SELECT ID_EJEMPLAR, CEDULA
    INTO v_id_ejemplar, v_cedula
    FROM PRESTAMOS
    WHERE ID_PRESTAMO = :NEW.ID_PRESTAMO;

    UPDATE PRESTAMOS
    SET ESTADO = 'Devuelto'
    WHERE ID_PRESTAMO = :NEW.ID_PRESTAMO;

    UPDATE EJEMPLARES
    SET DISPONIBLE =
        CASE
            WHEN ESTADO_CONSERVACION = 'Dañado' THEN 'N'
            ELSE 'S'
        END
    WHERE ID_EJEMPLAR = v_id_ejemplar;

    INSERT INTO HISTORIAL_MOVIMIENTOS (
        ID_HISTORIAL,
        ID_PRESTAMO,
        CEDULA,
        ID_EJEMPLAR,
        TIPO_MOVIMIENTO,
        FECHA_MOVIMIENTO,
        DESCRIPCION
    )
    VALUES (
        SEQ_HISTORIAL.NEXTVAL,
        :NEW.ID_PRESTAMO,
        v_cedula,
        v_id_ejemplar,
        'DEVOLUCION',
        SYSDATE,
        'Devolución registrada. Días de retraso: ' ||
        :NEW.DIAS_RETRASO ||
        '. Penalización: USD ' ||
        TO_CHAR(:NEW.PENALIZACION, 'FM9999990.00')
    );
END;
/

--8. Trigger para registrar renovaciones--
CREATE OR REPLACE TRIGGER TRG_HISTORIAL_RENOVACION
AFTER UPDATE OF FECHA_DEVOLUCION
ON PRESTAMOS
FOR EACH ROW
BEGIN
    IF :OLD.FECHA_DEVOLUCION <> :NEW.FECHA_DEVOLUCION THEN
        INSERT INTO HISTORIAL_MOVIMIENTOS (
            ID_HISTORIAL,
            ID_PRESTAMO,
            CEDULA,
            ID_EJEMPLAR,
            TIPO_MOVIMIENTO,
            FECHA_MOVIMIENTO,
            DESCRIPCION
        )
        VALUES (
            SEQ_HISTORIAL.NEXTVAL,
            :NEW.ID_PRESTAMO,
            :NEW.CEDULA,
            :NEW.ID_EJEMPLAR,
            'RENOVACION',
            SYSDATE,
            'Préstamo renovado. Fecha anterior: ' ||
            TO_CHAR(:OLD.FECHA_DEVOLUCION, 'DD/MM/YYYY') ||
            '. Nueva fecha: ' ||
            TO_CHAR(:NEW.FECHA_DEVOLUCION, 'DD/MM/YYYY')
        );
    END IF;
END;
/

--10. Procedimiento para registrar una devolución--
CREATE OR REPLACE PROCEDURE PR_REGISTRAR_DEVOLUCION (
    p_id_prestamo IN INT,
    p_fecha_recepcion IN DATE DEFAULT SYSDATE,
    p_id_devolucion OUT INT
)
IS
    v_estado PRESTAMOS.ESTADO%TYPE;
BEGIN
    BEGIN
        SELECT ESTADO
        INTO v_estado
        FROM PRESTAMOS
        WHERE ID_PRESTAMO = p_id_prestamo
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20040,
                'El préstamo indicado no existe.'
            );
    END;

    IF v_estado = 'Devuelto' THEN
        RAISE_APPLICATION_ERROR(
            -20041,
            'El préstamo ya fue devuelto.'
        );
    END IF;

    p_id_devolucion := SEQ_DEVOLUCIONES.NEXTVAL;

    INSERT INTO DEVOLUCIONES (
        ID_DEVOLUCION,
        ID_PRESTAMO,
        FECHA_RECEPCION,
        DIAS_RETRASO,
        PENALIZACION
    )
    VALUES (
        p_id_devolucion,
        p_id_prestamo,
        p_fecha_recepcion,
        0,
        0
    );

    DBMS_OUTPUT.PUT_LINE(
        'Devolución registrada correctamente.'
    );

    DBMS_OUTPUT.PUT_LINE(
        'Código de devolución: ' || p_id_devolucion
    );
END;
/

--11. Procedimiento para renovar un préstamo--
CREATE OR REPLACE PROCEDURE PR_RENOVAR_PRESTAMO (
    p_id_prestamo IN INT,
    p_dias_adicionales IN INT DEFAULT 7
)
IS
    v_estado PRESTAMOS.ESTADO%TYPE;
    v_fecha_limite PRESTAMOS.FECHA_DEVOLUCION%TYPE;
BEGIN
    IF p_dias_adicionales <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20050,
            'La cantidad de días adicionales debe ser mayor que cero.'
        );
    END IF;

    BEGIN
        SELECT ESTADO, FECHA_DEVOLUCION
        INTO v_estado, v_fecha_limite
        FROM PRESTAMOS
        WHERE ID_PRESTAMO = p_id_prestamo
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20051,
                'El préstamo indicado no existe.'
            );
    END;

    IF v_estado <> 'Activo' THEN
        RAISE_APPLICATION_ERROR(
            -20052,
            'Solo se pueden renovar préstamos activos.'
        );
    END IF;

    IF TRUNC(SYSDATE) > TRUNC(v_fecha_limite) THEN
        RAISE_APPLICATION_ERROR(
            -20053,
            'No se puede renovar un préstamo cuya fecha límite ya venció.'
        );
    END IF;

    UPDATE PRESTAMOS
    SET FECHA_DEVOLUCION =
        FECHA_DEVOLUCION + p_dias_adicionales
    WHERE ID_PRESTAMO = p_id_prestamo;

    DBMS_OUTPUT.PUT_LINE(
        'Préstamo renovado correctamente.'
    );

    DBMS_OUTPUT.PUT_LINE(
        'Días adicionales: ' || p_dias_adicionales
    );
END;
/

--12. Procedimiento para aplicar o recalcular una multa--
CREATE OR REPLACE PROCEDURE PR_APLICAR_MULTA (
    p_id_prestamo IN INT,
    p_multa OUT NUMBER
)
IS
    v_fecha_limite PRESTAMOS.FECHA_DEVOLUCION%TYPE;
    v_fecha_recepcion DEVOLUCIONES.FECHA_RECEPCION%TYPE;
    v_dias_retraso INT;
BEGIN
    BEGIN
        SELECT
            P.FECHA_DEVOLUCION,
            D.FECHA_RECEPCION
        INTO
            v_fecha_limite,
            v_fecha_recepcion
        FROM PRESTAMOS P
        INNER JOIN DEVOLUCIONES D
            ON D.ID_PRESTAMO = P.ID_PRESTAMO
        WHERE P.ID_PRESTAMO = p_id_prestamo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20060,
                'El préstamo no posee una devolución registrada.'
            );
    END;

    v_dias_retraso :=
        GREATEST(
            TRUNC(v_fecha_recepcion) - TRUNC(v_fecha_limite),
            0
        );

    p_multa := v_dias_retraso * 0.50;

    UPDATE DEVOLUCIONES
    SET DIAS_RETRASO = v_dias_retraso,
        PENALIZACION = p_multa
    WHERE ID_PRESTAMO = p_id_prestamo;

    DBMS_OUTPUT.PUT_LINE(
        'Multa actualizada correctamente.'
    );

    DBMS_OUTPUT.PUT_LINE(
        'Días de retraso: ' || v_dias_retraso
    );

    DBMS_OUTPUT.PUT_LINE(
        'Multa: USD ' || TO_CHAR(p_multa, 'FM9999990.00')
    );
END;
/

--13. Prueba completa de préstamo--
SET SERVEROUTPUT ON;
DECLARE
    v_id_prestamo INT;
BEGIN
    PR_REGISTRAR_PRESTAMO(
        p_cedula         => '0987654321',
        p_id_libro       => 20,
        p_dias_prestamo  => 7,
        p_id_prestamo    => v_id_prestamo
    );

    DBMS_OUTPUT.PUT_LINE(
        'Préstamo generado: ' || v_id_prestamo
    );

    COMMIT;
END;
/


--Comprobar el préstamo--

SELECT
    P.ID_PRESTAMO,
    P.CEDULA,
    U.NOMBRE AS USUARIO,
    P.ID_EJEMPLAR,
    L.TITULO,
    P.FECHA_PRESTAMO,
    P.FECHA_DEVOLUCION,
    P.ESTADO
FROM PRESTAMOS P
INNER JOIN USUARIOS U
    ON U.CEDULA = P.CEDULA
INNER JOIN EJEMPLARES E
    ON E.ID_EJEMPLAR = P.ID_EJEMPLAR
INNER JOIN LIBROS L
    ON L.ID_LIBRO = E.ID_LIBRO
ORDER BY P.ID_PRESTAMO;

--Comprobar que el ejemplar está ocupado--
SELECT
    E.ID_EJEMPLAR,
    L.TITULO,
    E.ESTADO_CONSERVACION,
    E.DISPONIBLE
FROM EJEMPLARES E
INNER JOIN LIBROS L
    ON L.ID_LIBRO = E.ID_LIBRO
ORDER BY E.ID_EJEMPLAR;

--14. Prueba de renovación--
BEGIN
    PR_RENOVAR_PRESTAMO(
        p_id_prestamo     => 1000,
        p_dias_adicionales => 5
    );

    COMMIT;
END;
/
--Verificar la nueva fecha--
SELECT
    ID_PRESTAMO,
    FECHA_PRESTAMO,
    FECHA_DEVOLUCION,
    ESTADO
FROM PRESTAMOS
WHERE ID_PRESTAMO = 1000;

--15. Prueba de devolución sin retraso--
DECLARE
    v_id_devolucion INT;
BEGIN
    PR_REGISTRAR_DEVOLUCION(
        p_id_prestamo    => 1000,
        p_fecha_recepcion => SYSDATE,
        p_id_devolucion  => v_id_devolucion
    );

    DBMS_OUTPUT.PUT_LINE(
        'Devolución generada: ' || v_id_devolucion
    );

    COMMIT;
END;
/

--Verificar la devolución--
SELECT
    ID_DEVOLUCION,
    ID_PRESTAMO,
    FECHA_RECEPCION,
    DIAS_RETRASO,
    PENALIZACION
FROM DEVOLUCIONES
WHERE ID_PRESTAMO = 1000;

--16. Prueba de devolución atrasada--
DECLARE
    v_id_prestamo INT;
BEGIN
    PR_REGISTRAR_PRESTAMO(
        p_cedula        => '0912345678',
        p_id_libro      => 20,
        p_dias_prestamo => 7,
        p_id_prestamo   => v_id_prestamo
    );

    DBMS_OUTPUT.PUT_LINE(
        'Préstamo para prueba de atraso: ' || v_id_prestamo
    );

    COMMIT;
END;
/
--Suponiendo que el código generado sea 1001, se registra una devolución 10 días después de la fecha actual --
DECLARE
    v_id_devolucion INT;
BEGIN
    PR_REGISTRAR_DEVOLUCION(
        p_id_prestamo     => 1001,
        p_fecha_recepcion => SYSDATE + 10,
        p_id_devolucion   => v_id_devolucion
    );

    DBMS_OUTPUT.PUT_LINE(
        'Devolución atrasada: ' || v_id_devolucion
    );

    COMMIT;
END;
/
--Consultar el resultado--
SELECT
    D.ID_DEVOLUCION,
    D.ID_PRESTAMO,
    P.FECHA_DEVOLUCION AS FECHA_LIMITE,
    D.FECHA_RECEPCION,
    D.DIAS_RETRASO,
    D.PENALIZACION
FROM DEVOLUCIONES D
INNER JOIN PRESTAMOS P
    ON P.ID_PRESTAMO = D.ID_PRESTAMO
WHERE D.ID_PRESTAMO = 1001;

--17. Consultar el historial--
SELECT
    H.ID_HISTORIAL,
    H.ID_PRESTAMO,
    H.CEDULA,
    U.NOMBRE AS USUARIO,
    H.ID_EJEMPLAR,
    L.TITULO,
    H.TIPO_MOVIMIENTO,
    H.FECHA_MOVIMIENTO,
    H.DESCRIPCION
FROM HISTORIAL_MOVIMIENTOS H
LEFT JOIN USUARIOS U
    ON U.CEDULA = H.CEDULA
LEFT JOIN EJEMPLARES E
    ON E.ID_EJEMPLAR = H.ID_EJEMPLAR
LEFT JOIN LIBROS L
    ON L.ID_LIBRO = E.ID_LIBRO
ORDER BY H.ID_HISTORIAL;

--18. Consultar préstamos activos--
SELECT
    P.ID_PRESTAMO,
    U.NOMBRE AS USUARIO,
    L.TITULO,
    P.FECHA_PRESTAMO,
    P.FECHA_DEVOLUCION,
    P.ESTADO
FROM PRESTAMOS P
INNER JOIN USUARIOS U
    ON U.CEDULA = P.CEDULA
INNER JOIN EJEMPLARES E
    ON E.ID_EJEMPLAR = P.ID_EJEMPLAR
INNER JOIN LIBROS L
    ON L.ID_LIBRO = E.ID_LIBRO
WHERE P.ESTADO = 'Activo'
ORDER BY P.FECHA_DEVOLUCION;

--19. Consultar préstamos vencidos--
SELECT
    P.ID_PRESTAMO,
    U.NOMBRE AS USUARIO,
    L.TITULO,
    P.FECHA_DEVOLUCION,
    TRUNC(SYSDATE) - TRUNC(P.FECHA_DEVOLUCION)
        AS DIAS_VENCIDOS,
    P.ESTADO
FROM PRESTAMOS P
INNER JOIN USUARIOS U
    ON U.CEDULA = P.CEDULA
INNER JOIN EJEMPLARES E
    ON E.ID_EJEMPLAR = P.ID_EJEMPLAR
INNER JOIN LIBROS L
    ON L.ID_LIBRO = E.ID_LIBRO
WHERE P.ESTADO = 'Vencido'
   OR (
       P.ESTADO = 'Activo'
       AND TRUNC(SYSDATE) > TRUNC(P.FECHA_DEVOLUCION)
   )
ORDER BY P.FECHA_DEVOLUCION;

--20. Revisar errores de procedimientos y triggers--
SELECT
    NAME,
    TYPE,
    LINE,
    POSITION,
    TEXT
FROM USER_ERRORS
ORDER BY NAME, SEQUENCE;

--procedimineto almacenado--
CREATE OR REPLACE PROCEDURE PR_REGISTRAR_PRESTAMO (
    p_cedula         IN VARCHAR2,
    p_id_libro       IN INT,
    p_dias_prestamo  IN INT DEFAULT 7,
    p_id_prestamo    OUT INT
)
IS
    v_estatus              USUARIOS.ESTATUS%TYPE;
    v_id_ejemplar          EJEMPLARES.ID_EJEMPLAR%TYPE;
    v_prestamos_vencidos   INT;
    v_existe_libro         INT;
BEGIN
    ---------------------------------------------------------
    -- 1. Validar cantidad de días
    ---------------------------------------------------------
    IF p_dias_prestamo IS NULL OR p_dias_prestamo <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20030,
            'La cantidad de días del préstamo debe ser mayor que cero.'
        );
    END IF;

    ---------------------------------------------------------
    -- 2. Verificar que el usuario exista
    ---------------------------------------------------------
    BEGIN
        SELECT ESTATUS
        INTO v_estatus
        FROM USUARIOS
        WHERE CEDULA = p_cedula;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20031,
                'El usuario indicado no existe.'
            );
    END;

    ---------------------------------------------------------
    -- 3. Verificar que el usuario esté activo
    ---------------------------------------------------------
    IF v_estatus <> 'Activo' THEN
        RAISE_APPLICATION_ERROR(
            -20032,
            'El usuario no está activo y no puede solicitar préstamos.'
        );
    END IF;

    ---------------------------------------------------------
    -- 4. Verificar que el libro exista
    ---------------------------------------------------------
    SELECT COUNT(*)
    INTO v_existe_libro
    FROM LIBROS
    WHERE ID_LIBRO = p_id_libro;

    IF v_existe_libro = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20033,
            'El libro solicitado no existe.'
        );
    END IF;

    ---------------------------------------------------------
    -- 5. Verificar préstamos vencidos del usuario
    ---------------------------------------------------------
    SELECT COUNT(*)
    INTO v_prestamos_vencidos
    FROM PRESTAMOS
    WHERE CEDULA = p_cedula
      AND (
          ESTADO = 'Vencido'
          OR (
              ESTADO = 'Activo'
              AND TRUNC(SYSDATE) > TRUNC(FECHA_DEVOLUCION)
          )
      );

    IF v_prestamos_vencidos > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20034,
            'El usuario tiene préstamos vencidos.'
        );
    END IF;

    ---------------------------------------------------------
    -- 6. Buscar un ejemplar disponible
    ---------------------------------------------------------
    SELECT MIN(ID_EJEMPLAR)
    INTO v_id_ejemplar
    FROM EJEMPLARES
    WHERE ID_LIBRO = p_id_libro
      AND DISPONIBLE = 'S'
      AND ESTADO_CONSERVACION <> 'Dañado';

    IF v_id_ejemplar IS NULL THEN
        RAISE_APPLICATION_ERROR(
            -20035,
            'No existen ejemplares disponibles para este libro.'
        );
    END IF;

    ---------------------------------------------------------
    -- 7. Generar el código del préstamo
    ---------------------------------------------------------
    p_id_prestamo := SEQ_PRESTAMOS.NEXTVAL;

    ---------------------------------------------------------
    -- 8. Registrar el préstamo
    ---------------------------------------------------------
    INSERT INTO PRESTAMOS (
        ID_PRESTAMO,
        CEDULA,
        ID_EJEMPLAR,
        FECHA_PRESTAMO,
        FECHA_DEVOLUCION,
        ESTADO
    )
    VALUES (
        p_id_prestamo,
        p_cedula,
        v_id_ejemplar,
        SYSDATE,
        SYSDATE + p_dias_prestamo,
        'Activo'
    );

    ---------------------------------------------------------
    -- 9. Actualizar disponibilidad
    ---------------------------------------------------------
    UPDATE EJEMPLARES
    SET DISPONIBLE = 'N'
    WHERE ID_EJEMPLAR = v_id_ejemplar;

    DBMS_OUTPUT.PUT_LINE('Préstamo registrado correctamente.');
    DBMS_OUTPUT.PUT_LINE(
        'ID del préstamo: ' || p_id_prestamo
    );
    DBMS_OUTPUT.PUT_LINE(
        'Ejemplar asignado: ' || v_id_ejemplar
    );
    DBMS_OUTPUT.PUT_LINE(
        'Fecha límite: ' ||
        TO_CHAR(SYSDATE + p_dias_prestamo, 'DD/MM/YYYY')
    );
END;
/

-- TABLAS DE DIMENSIONES--
CREATE TABLE DIM_TIEMPO (
    ID_TIEMPO INT PRIMARY KEY,
    FECHA DATE NOT NULL,
    DIA INT NOT NULL,
    NOMBRE_DIA VARCHAR2(15),
    ES_FIN_SEMANA CHAR(1),
    MES INT NOT NULL,
    NOMBRE_MES VARCHAR2(20),
    TRIMESTRE INT,
    ANIO INT NOT NULL
);

CREATE TABLE DIM_USUARIOS (
    ID_USUARIO_DW INT PRIMARY KEY,
    CEDULA VARCHAR2(20) NOT NULL,
    NOMBRE VARCHAR2(150),
    ESTATUS VARCHAR2(20)
);

CREATE TABLE DIM_AUTORES (
    ID_AUTOR_DW INT PRIMARY KEY,
    ID_AUTOR INT NOT NULL,
    NOMBRE VARCHAR2(150)
);

CREATE TABLE DIM_CATEGORIAS (
    ID_CATEGORIA_DW INT PRIMARY KEY,
    ID_CATEGORIA INT NOT NULL,
    NOMBRE VARCHAR2(100),
    DESCRIPCION VARCHAR2(255)
);

CREATE TABLE DIM_LIBROS (
    ID_LIBRO_DW INT PRIMARY KEY,
    ID_LIBRO INT NOT NULL,
    TITULO VARCHAR2(200)
);

--TABLA DE HECHOS-- 
CREATE TABLE HECHOS_PRESTAMOS (
    ID_HECHO INT PRIMARY KEY,
    ID_TIEMPO INT NOT NULL,
    ID_USUARIO_DW INT NOT NULL,
    ID_LIBRO_DW INT NOT NULL,
    ID_AUTOR_DW INT NOT NULL,
    ID_CATEGORIA_DW INT NOT NULL,
    ID_PRESTAMO INT,
    ESTADO_PRESTAMO VARCHAR2(20),
    DIAS_RETRASO INT,
    PENALIZACION NUMBER(10,2),
    CANTIDAD_PRESTAMOS INT,

    CONSTRAINT FK_HP_TIEMPO
        FOREIGN KEY (ID_TIEMPO)
        REFERENCES DIM_TIEMPO(ID_TIEMPO),

    CONSTRAINT FK_HP_USUARIO
        FOREIGN KEY (ID_USUARIO_DW)
        REFERENCES DIM_USUARIOS(ID_USUARIO_DW),

    CONSTRAINT FK_HP_LIBRO
        FOREIGN KEY (ID_LIBRO_DW)
        REFERENCES DIM_LIBROS(ID_LIBRO_DW),

    CONSTRAINT FK_HP_AUTOR
        FOREIGN KEY (ID_AUTOR_DW)
        REFERENCES DIM_AUTORES(ID_AUTOR_DW),

    CONSTRAINT FK_HP_CATEGORIA
        FOREIGN KEY (ID_CATEGORIA_DW)
        REFERENCES DIM_CATEGORIAS(ID_CATEGORIA_DW)
);

-----ETL---------

CREATE OR REPLACE PROCEDURE SP_ETL_BIBLIOTECA_DW
AS
BEGIN

    -- LIMPIAR TABLAS DEL DATA WAREHOUSE -- 
    DELETE FROM HECHOS_PRESTAMOS;
    DELETE FROM DIM_LIBROS;
    DELETE FROM DIM_CATEGORIAS;
    DELETE FROM DIM_AUTORES;
    DELETE FROM DIM_USUARIOS;
    DELETE FROM DIM_TIEMPO;

    -- CARGAR DIMENSION TIEMPO -- 
    INSERT INTO DIM_TIEMPO
    (
        ID_TIEMPO,
        FECHA,
        DIA,
        NOMBRE_DIA,
        ES_FIN_SEMANA,
        MES,
        NOMBRE_MES,
        TRIMESTRE,
        ANIO
    )
    SELECT DISTINCT
        ROW_NUMBER() OVER (ORDER BY TRUNC(P.FECHA_PRESTAMO)),
        TRUNC(P.FECHA_PRESTAMO),
        EXTRACT(DAY FROM TRUNC(P.FECHA_PRESTAMO)),
        TO_CHAR(TRUNC(P.FECHA_PRESTAMO), 'DAY'),
        CASE
            WHEN TO_CHAR(TRUNC(P.FECHA_PRESTAMO), 'D') IN ('1','7')
            THEN 'S'
            ELSE 'N'
        END,
        EXTRACT(MONTH FROM TRUNC(P.FECHA_PRESTAMO)),
        TO_CHAR(TRUNC(P.FECHA_PRESTAMO), 'MONTH'),
        CEIL(EXTRACT(MONTH FROM TRUNC(P.FECHA_PRESTAMO))/3),
        EXTRACT(YEAR FROM TRUNC(P.FECHA_PRESTAMO))
    FROM PRESTAMOS P;

    -- CARGAR DIMENSION USUARIOS
    INSERT INTO DIM_USUARIOS
    (
        ID_USUARIO_DW,
        CEDULA,
        NOMBRE,
        ESTATUS
    )
    SELECT
        ROW_NUMBER() OVER(ORDER BY U.CEDULA),
        U.CEDULA,
        U.NOMBRE,
        U.ESTATUS
    FROM USUARIOS U;

    -- CARGAR DIMENSION AUTORES--
    INSERT INTO DIM_AUTORES
    (
        ID_AUTOR_DW,
        ID_AUTOR,
        NOMBRE
    )
    SELECT
        ROW_NUMBER() OVER(ORDER BY A.ID_AUTOR),
        A.ID_AUTOR,
        A.NOMBRE
    FROM AUTOR A;

    -- CARGAR DIMENSION CATEGORIAS--
    INSERT INTO DIM_CATEGORIAS
    (
        ID_CATEGORIA_DW,
        ID_CATEGORIA,
        NOMBRE,
        DESCRIPCION
    )

    SELECT
        ROW_NUMBER() OVER(ORDER BY C.ID_CATEGORIA),
        C.ID_CATEGORIA,
        C.NOMBRE,
        C.DESCRIPCION
    FROM CATEGORIA C;

    -- CARGAR DIMENSION LIBROS--
    INSERT INTO DIM_LIBROS
    (
        ID_LIBRO_DW,
        ID_LIBRO,
        TITULO
    )

    SELECT
        ROW_NUMBER() OVER(ORDER BY L.ID_LIBRO),
        L.ID_LIBRO,
        L.TITULO
    FROM LIBROS L;

    -- CARGAR TABLA DE HECHOS PRESTAMOS--
    INSERT INTO HECHOS_PRESTAMOS
    (
        ID_HECHO,
        ID_TIEMPO,
        ID_USUARIO_DW,
        ID_LIBRO_DW,
        ID_AUTOR_DW,
        ID_CATEGORIA_DW,
        ID_PRESTAMO,
        ESTADO_PRESTAMO,
        DIAS_RETRASO,
        PENALIZACION,
        CANTIDAD_PRESTAMOS
    )

    SELECT
        ROW_NUMBER() OVER(ORDER BY P.ID_PRESTAMO),
        T.ID_TIEMPO,
        U.ID_USUARIO_DW,
        L.ID_LIBRO_DW,
        A.ID_AUTOR_DW,
        C.ID_CATEGORIA_DW,
        P.ID_PRESTAMO,
        P.ESTADO,

        CASE
            WHEN P.FECHA_DEVOLUCION IS NOT NULL
            THEN P.FECHA_DEVOLUCION - P.FECHA_PRESTAMO
            ELSE 0
        END,

        CASE
            WHEN P.FECHA_DEVOLUCION IS NOT NULL
            THEN (P.FECHA_DEVOLUCION - P.FECHA_PRESTAMO) * 0.50
            ELSE 0
        END,
        1
    FROM PRESTAMOS P

    INNER JOIN EJEMPLARES E
        ON P.ID_EJEMPLAR = E.ID_EJEMPLAR

    INNER JOIN DIM_TIEMPO T
        ON T.FECHA = TRUNC(P.FECHA_PRESTAMO)
   
    INNER JOIN DIM_USUARIOS U
        ON U.CEDULA = P.CEDULA
    
    INNER JOIN LIBROS LB
    ON LB.ID_LIBRO = E.ID_LIBRO
  
    INNER JOIN DIM_LIBROS L
    ON L.ID_LIBRO = LB.ID_LIBRO
   
    INNER JOIN DIM_AUTORES A
    ON A.ID_AUTOR = LB.ID_AUTOR
   
    INNER JOIN DIM_CATEGORIAS C
    ON C.ID_CATEGORIA = LB.ID_CATEGORIA;

    --GUARDAR CAMBIOS--
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

EXEC SP_ETL_BIBLIOTECA_DW; 

--Vistas Materializadas--
--1. Libros más prestados
CREATE MATERIALIZED VIEW MV_LIBROS_MAS_PRESTADOS
BUILD IMMEDIATE
REFRESH COMPLETE
ON DEMAND
AS

SELECT
    L.TITULO AS LIBRO,
    SUM(H.CANTIDAD_PRESTAMOS) AS TOTAL_PRESTAMOS

FROM HECHOS_PRESTAMOS H

INNER JOIN DIM_LIBROS L
    ON H.ID_LIBRO_DW = L.ID_LIBRO_DW

GROUP BY L.TITULO;
SELECT *
FROM MV_LIBROS_MAS_PRESTADOS;

--2. Prestamos por mes
CREATE MATERIALIZED VIEW MV_PRESTAMOS_POR_MES
BUILD IMMEDIATE
REFRESH COMPLETE
ON DEMAND
AS
SELECT
    T.ANIO,
    T.MES,
    T.NOMBRE_MES,
    SUM(H.CANTIDAD_PRESTAMOS) AS TOTAL_PRESTAMOS
FROM HECHOS_PRESTAMOS H
INNER JOIN DIM_TIEMPO T
    ON H.ID_TIEMPO = T.ID_TIEMPO
GROUP BY
    T.ANIO,
    T.MES,
    T.NOMBRE_MES;

SELECT *
FROM MV_PRESTAMOS_POR_MES
ORDER BY ANIO, MES;

SELECT
    L.TITULO,
    SUM(H.CANTIDAD_PRESTAMOS) AS TOTAL_PRESTAMOS
FROM HECHOS_PRESTAMOS H
JOIN DIM_LIBROS L
ON H.ID_LIBRO_DW = L.ID_LIBRO_DW
GROUP BY L.TITULO;
