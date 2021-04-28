CREATE TABLE usuario (
    user_nombre VARCHAR2(30) NOT NULL,
    user_apellido VARCHAR2(30) NOT NULL,
    user_fe_naci VARCHAR2(30),
    user_run NUMBER(9) NOT NULL,
    DTYPE varchar2(20) not null,
    tipo_usuario VARCHAR2(50)
);
drop table usuario;
ALTER TABLE usuario ADD CONSTRAINT usuario_pk PRIMARY KEY (user_run);
alter table usuario drop column id_usuario;
alter table usuario drop constraint usuario_pk;
ALTER TABLE usuario MODIFY ( user_fe_naci VARCHAR2(20));
ALTER TABLE USUARIO add column password varchar2(20) constraint;

ALTER TABLE usuario ADD CONSTRAINT cx_tipo_usuario
CHECK ( tipo_usuario IN ( 'Cliente', 'Profesional', 'Administrativo'));
alter table usuario rename column tipo_usuario to dtype;
CREATE TABLE cliente (
    rut_cliente NUMBER(9) NOT NULL,
    cli_telefono VARCHAR2(20) NOT NULL,
    cli_afp VARCHAR2(30),
    cli_sistema_salud NUMBER(2),
    cli_direccion VARCHAR2(100),  
    cli_comuna VARCHAR2(50),
    cli_edad NUMBER(3) NOT NULL
);
ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY (rut_cliente);

ALTER TABLE cliente ADD CONSTRAINT UK_telefono UNIQUE (cli_telefono);
ALTER TABLE cliente ADD CONSTRAINT CX_sistema_salud CHECK (cli_sistema_salud IN (1,2));
ALTER TABLE cliente ADD CONSTRAINT usuario_cliente_fk
FOREIGN KEY (rut_cliente ) REFERENCES usuario (user_run)
ON DELETE CASCADE;

-- TABLA CAPACITACION
CREATE TABLE capacitacion (
 id_capacitacion NUMBER(9) NOT NULL,
 cap_fecha DATE,
 cap_hora DATE,
 cap_lugar VARCHAR2(50) NOT NULL,
 cap_duracion NUMBER(3),
 cap_cantidad_asistentes NUMBER(5) NOT NULL,
 cap_cliente_rut_cliente NUMBER(9) --NOT NULL
);
alter table capacitacion rename column cliente_rut_cliente to cap_cliente_rut_cliente;
ALTER TABLE capacitacion ADD CONSTRAINT capacitacion_pk PRIMARY KEY (id_capacitacion );
ALTER TABLE capacitacion ADD CONSTRAINT capacitacion_cliente_fk 
FOREIGN KEY (cliente_rut_cliente) REFERENCES cliente ( rut_cliente )
ON DELETE CASCADE;
ALTER TABLE capacitacion MODIFY ( cap_fecha VARCHAR2(10));
ALTER TABLE capacitacion MODIFY ( cap_hora VARCHAR2(5));
 
CREATE TABLE asistentes (
 id_asistente NUMBER(9) NOT NULL,
 asist_nombre_completo VARCHAR2(100) NOT NULL,
 asist_edad NUMBER(3) NOT NULL,
 Cap_id_capacitacion NUMBER(9) NOT NULL
);
ALTER TABLE asistentes ADD CONSTRAINT asistentes_pk PRIMARY KEY ( id_asistente );
ALTER TABLE asistentes ADD CONSTRAINT asistentes_capacitacion_fk
FOREIGN KEY ( cap_id_capacitacion ) REFERENCES capacitacion ( id_capacitacion )
ON DELETE CASCADE;
 
 CREATE TABLE accidente (
 id_accidente NUMBER(9) NOT NULL,
 acci_fecha DATE NOT NULL,
 acci_hora DATE,
 acci_lugar VARCHAR2(150) NOT NULL,
 acci_origen VARCHAR2(100),
 acci_consecuencias VARCHAR2(100),
 Cliente_rut_cliente NUMBER(9) NOT NULL
 );
 ALTER TABLE accidente ADD CONSTRAINT accidente_pk PRIMARY KEY (id_accidente);
ALTER TABLE accidente ADD CONSTRAINT accidente_cliente_fk 
FOREIGN KEY ( Cliente_rut_cliente) REFERENCES cliente ( rut_cliente )
ON DELETE CASCADE;


------------------------------------------------------------------
--GRUPAL 6
------------------------------------------------------------------

-- RESTRICCIONES Y DROP
ALTER TABLE capacitacion MODIFY ( cap_fecha NOT NULL );
ALTER TABLE capacitacion MODIFY ( cap_duracion NUMBER(4));
ALTER TABLE capacitacion DROP COLUMN cap_cantidad_asistentes;

-- TABLA ASISTENTES: NUEVAS COLUMNAS
ALTER TABLE asistentes ADD (
    asist_correo VARCHAR2(70), 
    asist_telefono VARCHAR2(20)
    );
-- NUEVA TABLA VISITAS
CREATE TABLE visita (
 id_visita NUMBER(9) NOT NULL,
 vis_fecha DATE NOT NULL,
 vis_hora DATE,
 vis_lugar VARCHAR2(50) NOT NULL,
 vis_comentarios VARCHAR2(250) NOT NULL,
 Cliente_rut_cliente NUMBER(9) NOT NULL
 );
 ALTER TABLE visita ADD CONSTRAINT visita_pk PRIMARY KEY (id_visita);
ALTER TABLE visita ADD CONSTRAINT visita_cliente_fk 
FOREIGN KEY ( cliente_rut_cliente)REFERENCES cliente ( rut_cliente )
ON DELETE CASCADE;
------------------------------------------------------------------
--GRUPAL 8
------------------------------------------------------------------

CREATE TABLE chequeo_Tipo (
    id_chequeo NUMBER(5) NOT NULL,
    che_nombre VARCHAR2(30) NOT NULL
);
 ALTER TABLE chequeo_Tipo ADD CONSTRAINT chequeo_pk PRIMARY KEY (
id_chequeo);

CREATE TABLE registro_Chequeo (
    id_Registro_Chequeo NUMBER(8) NOT NULL,
    visita_id_visita NUMBER(9) NOT NULL,
    chequeo_tipo_id_chequeo NUMBER(5) NOT NULL ,
    estado_Cumplimiento VARCHAR2(15) NOT NULL-- cumple, cumple con observaciones, no cumple)
);
 ALTER TABLE registro_Chequeo ADD CONSTRAINT registro_Chequeo_pk PRIMARY KEY (id_Registro_Chequeo);
-- FK REGISTROS POR VISITA
ALTER TABLE registro_Chequeo ADD CONSTRAINT registro_Chequeo_visita_fk 
FOREIGN KEY ( visita_id_visita) REFERENCES visita ( id_visita );
ALTER TABLE registro_Chequeo ADD CONSTRAINT reg_tipo_reg_che_tipo_fk 
FOREIGN KEY ( chequeo_tipo_id_chequeo) REFERENCES chequeo_tipo ( id_chequeo);
 
-- RESTRINGIENDO INPUT ESTADOCUMPLIMIENTO
ALTER TABLE registro_Chequeo ADD CONSTRAINT ck_estado_Cumplimiento
CHECK ( estado_Cumplimiento IN ( 'Cumple', 'Cumple con observaciones', 'No cumple'));

CREATE TABLE administrativo (
run_Adm NUMBER(9) NOT NULL,
adm_Correo VARCHAR2(30) ,
adm_Area VARCHAR2(20)
);
ALTER TABLE administrativo ADD CONSTRAINT administrativo_pk PRIMARY KEY (run_Adm);
-- FK USUARIO_ADM
ALTER TABLE administrativo ADD CONSTRAINT administrativo_usuario_fk 
FOREIGN KEY (run_Adm) REFERENCES usuario ( user_Run );
alter table administrativo rename column user_run to run_adm  ;
--TABLA PROFESIONAL
CREATE TABLE profesional (
    user_run NUMBER(9), --NOT NULL,
    pro_Telefono VARCHAR2(30) ,
    pro_Titulo VARCHAR2(30) ,
    pro_Proyecto VARCHAR2(30)
); 
drop table profesional;
ALTER TABLE profesional ADD CONSTRAINT profesional_pk PRIMARY KEY (user_run );
alter table administrativo rename column run_adm to user_run;
-- asociar a un usuario fk como adm y cliente

-- FK USUARIO_PROFESIONAL 
 ALTER TABLE profesional ADD CONSTRAINT profesional_usuario_fk 
 FOREIGN KEY (user_run ) REFERENCES usuario ( user_run );

alter table profesional drop constraint profesional_usuario_fk ;
------------------------------------------------------------------
--FINAL MODULO 2
------------------------------------------------------------------
-- TABLA PAGO
CREATE TABLE pago (
    id_pago NUMBER(6) NOT NULL, -- autoincremental
    pago_fecha DATE, 
    pago_monto NUMBER(12),
    pago_mes VARCHAR2(15),
    pago_año NUMBER(4),
    cliente_rut_Cliente NUMBER(9) 
);
ALTER TABLE pago ADD CONSTRAINT pago_pk PRIMARY KEY (id_Pago);
ALTER TABLE pago ADD CONSTRAINT cliente_pago_fk 
FOREIGN KEY (cliente_rut_Cliente)
REFERENCES cliente (rut_Cliente);
ALTER TABLE PAGO MODIFY (cliente_rut_cliente NOT NULL);

-- TABLA ASESORIA
CREATE TABLE asesoria (
id_asesoria NUMBER(4),
ases_Fecha_Realizacion DATE,
ases_Motivo_Solicita VARCHAR2(100),
pro_rut_Profesional NUMBER(9)
);
ALTER TABLE asesoria ADD CONSTRAINT asesoria_pk PRIMARY KEY (id_Asesoria);
--fk a profesional
ALTER TABLE asesoria ADD CONSTRAINT profesional_asesoria_fk 
FOREIGN KEY ( pro_rut_Profesional) REFERENCES profesional (ruT_Profesional);
ALTER TABLE ASESORIA MODIFY (pro_rut_profesional NOT NULL);

CREATE TABLE actividad_Mejora (
	id_actividad_Mejora NUMBER(6) NOT NULL, -- AUTOINCREMENTAL
	am_Titulo VARCHAR2(50),
	am_Descripcion VARCHAR2(250),
	am_PlazoRes NUMBER (3),-- dias
    asesoria_id_actividad_Mejora NUMBER(9)
);
ALTER TABLE actividad_Mejora ADD CONSTRAINT actividad_Mejora_pk PRIMARY KEY (id_actividad_Mejora);
--fk a actividadMejora
ALTER TABLE actividad_Mejora ADD CONSTRAINT mejora_profesional_fk FOREIGN KEY (asesoria_id_actividad_Mejora)
REFERENCES asesoria (id_asesoria);
ALTER TABLE actividad_mejora MODIFY (asesoria_id_actividad_mejora NOT NULL);


 --CREAR SECUENCIA
 CREATE SEQUENCE asis_sc
    START WITH 0
    MINVALUE 0
    MAXVALUE 100;
 CREATE SEQUENCE cap_sc 
    START WITH 0
    MINVALUE 0
    MAXVALUE 100;
 CREATE SEQUENCE acc_sc
    START WITH 0
    MINVALUE 0
    MAXVALUE 100;
CREATE SEQUENCE visita_sc
    START WITH 0
    MINVALUE 0
    MAXVALUE 100;
CREATE SEQUENCE reg_Chequeo_sc
   START WITH 0
    MINVALUE 0
    MAXVALUE 100;
CREATE SEQUENCE pago_sc
   START WITH 0
    MINVALUE 0
    MAXVALUE 100;
CREATE SEQUENCE act_sc
   START WITH 0
    MINVALUE 0
    MAXVALUE 100;
    
CREATE SEQUENCE usu_sc
   START WITH 0
    MINVALUE 0
    MAXVALUE 100;
--______________________________
------TRIGGERS ------------

--ID_ASISTENTES 
CREATE OR REPLACE TRIGGER TRIGGERASIST
BEFORE INSERT ON asistentes
FOR EACH ROW
  WHEN (new.id_asistente IS NULL)
BEGIN
  :new.id_asistente := asis_sc.NEXTVAL;
END;
/
--CAPACITACION
CREATE OR REPLACE TRIGGER TRIGGERCAP
BEFORE INSERT ON capacitacion
FOR EACH ROW
  WHEN (new.id_capacitacion IS NULL)
BEGIN
  :new.id_capacitacion:= cap_sc.NEXTVAL;
END;
/

--ACCIDENTE
CREATE OR REPLACE TRIGGER TRIGGERACC
BEFORE INSERT ON accidente
FOR EACH ROW
  WHEN (new.id_accidente IS NULL)
BEGIN
  :new.id_accidente:= acc_sc.NEXTVAL;
END;
/
DROP TRIGGER TRIGGERASIST;
-- ID_VISITA
CREATE OR REPLACE TRIGGER TRIGGERVIS
BEFORE INSERT ON visita
FOR EACH ROW
  WHEN (new.id_visita IS NULL)
BEGIN
  :new.id_visita := visita_sc.NEXTVAL;
END;
/
--ID_REGISTRO_CHEQUEO
CREATE OR REPLACE TRIGGER TRIGGERREG
BEFORE INSERT ON registro_Chequeo
FOR EACH ROW
  WHEN (new.id_Registro_Chequeo IS NULL)
BEGIN
  :new.id_Registro_Chequeo := reg_Chequeo_sc.NEXTVAL;
END;
/

-- ID_PAGO
CREATE OR REPLACE TRIGGER TRIGGERPAG
BEFORE INSERT ON pago
FOR EACH ROW
  WHEN (new.id_pago IS NULL)
BEGIN
  :new.id_pago := pago_sc.NEXTVAL;
END;
/
-- ID_ACTIVIDAD_MEJORA
CREATE OR REPLACE TRIGGER TRIGGERACT
BEFORE INSERT ON actividad_Mejora
FOR EACH ROW
  WHEN (new.id_actividad_Mejora IS NULL)
BEGIN
  :new.id_actividad_Mejora := act_sc.NEXTVAL;
END;
/
-- ID_USUARIO
CREATE OR REPLACE TRIGGER TRIGGERUSU
BEFORE INSERT ON usuario
FOR EACH ROW
  WHEN (new.id_usuario IS NULL)
BEGIN
  :new.id_usuario := usu_sc.NEXTVAL;
END;
/

alter table asesoria drop constraint profesional_asesoria_fk;

ALTER TABLE capacitacion ADD cap_cantidad_asistentes NUMBER(3);
ALTER TABLE capacitacion MODIFY ( cap_fecha VARCHAR2(10));
ALTER TABLE capacitacion MODIFY ( cap_hora VARCHAR2(5));
ALTER TABLE usuario MODIFY ( user_fe_naci VARCHAR2(20));
aLTER TABLE capacitacion MODIFY ( cliente_rut_cliente  null);
ALTER TABLE usuario rename column user_run to rut;
ALTER TABLE administrativo rename column run_adm to rut;
ALTER TABLE profesional rename column rut_profesional to rut;


ALTER TABLE usuario rename column   rut to user_run;
ALTER TABLE administrativo rename column rut to run_adm ;
ALTER TABLE profesional rename column rut to rut_profesional ;