-- Script para sembrar datos de prueba en la base de datos Turnosmart
USE turnosmart;

-- 1. Registrar a 'Juan Notario' (user 3) como Abogado/Notario en la tabla lawyers
INSERT INTO lawyers (user_id, colegiatura, specialization, bio, active, created_at)
VALUES (3, 'CAL-98765', 'Derecho Civil y Contractual', 'Abogado y Notario con más de 15 años de trayectoria profesional.', 1, NOW())
ON DUPLICATE KEY UPDATE colegiatura = VALUES(colegiatura), specialization = VALUES(specialization);

-- 2. Insertar nuevos usuarios (clientes y abogados adicionales)
INSERT IGNORE INTO users (id, first_name, last_name, email, phone, password_hash, enabled, created_at, updated_at, birth_date, civil_status, dni, gender, account_locked, failed_attempts) VALUES
(7, 'Maria', 'Lopez Lopez', 'maria@gmail.com', '987654321', '$2a$10$q6ggajP7HK8Wr7fEctWOZe4m7kNKokqfHvQ4jZyCqEAKqmX2Y.rC2', 1, NOW(), NOW(), '1990-05-15', 'Soltero/a', '45678912', 'F', 0, 0),
(8, 'Jose', 'Perez Garcia', 'jose@gmail.com', '976543210', '$2a$10$q6ggajP7HK8Wr7fEctWOZe4m7kNKokqfHvQ4jZyCqEAKqmX2Y.rC2', 1, NOW(), NOW(), '1985-09-20', 'Casado/a', '32145678', 'M', 0, 0),
(9, 'Ana', 'Gomez Ruiz', 'ana@gmail.com', '965432109', '$2a$10$q6ggajP7HK8Wr7fEctWOZe4m7kNKokqfHvQ4jZyCqEAKqmX2Y.rC2', 1, NOW(), NOW(), '1992-12-10', 'Divorciado/a', '98765432', 'F', 0, 0),
(10, 'Pedro', 'Ruiz Chavez', 'pedro@gmail.com', '954321098', '$2a$10$q6ggajP7HK8Wr7fEctWOZe4m7kNKokqfHvQ4jZyCqEAKqmX2Y.rC2', 1, NOW(), NOW(), '1988-03-25', 'Soltero/a', '74185296', 'M', 0, 0),
(11, 'Sofia', 'Castro Mendoza', 'sofia@turnosmart.com', '912345678', '$2a$10$q6ggajP7HK8Wr7fEctWOZe4m7kNKokqfHvQ4jZyCqEAKqmX2Y.rC2', 1, NOW(), NOW(), '1993-07-04', 'Soltero/a', '12398745', 'F', 0, 0);

-- 3. Vincular roles a los nuevos usuarios
INSERT IGNORE INTO user_roles (user_id, role_id) VALUES
(7, 1),  -- Maria -> ROLE_CLIENTE
(8, 1),  -- Jose -> ROLE_CLIENTE
(9, 1),  -- Ana -> ROLE_CLIENTE
(10, 1), -- Pedro -> ROLE_CLIENTE
(11, 3); -- Sofia -> ROLE_NOTARIO

-- 4. Registrar a 'Sofia Castro' (user 11) como Abogada en la tabla lawyers
INSERT INTO lawyers (user_id, colegiatura, specialization, bio, active, created_at)
VALUES (11, 'CAL-74321', 'Derecho de Familia', 'Abogada especialista en derecho de familia y poderes de representación.', 1, NOW())
ON DUPLICATE KEY UPDATE colegiatura = VALUES(colegiatura), specialization = VALUES(specialization);

-- 5. Limpiar citas antiguas para evitar conflictos si se ejecuta de nuevo
DELETE FROM appointments;

-- 6. Insertar Citas/Trámites de Prueba realistas
INSERT INTO appointments 
(id, ticket_number, client_id, lawyer_id, procedure_type_id, appointment_date, appointment_time, client_dni, notes, status, created_at, updated_at, priority, representation_type, identifier, business_name, is_paid, payment_method, operation_number)
VALUES
(1, 'TS-C5A24B91', 2, 1, 1, '2026-07-05', '09:30:00', '87654321', 'Poder para trámites bancarios en BCP.', 'FIRMADO', DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), 'NORMAL', NULL, NULL, NULL, 1, 'YAPE', '012345'),
(2, 'TS-D123A456', 2, 2, 2, '2026-07-06', '10:00:00', '87654321', 'Representación legal de la empresa Soluciones S.A.C.', 'ENTREGADO', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), 'ALTA', 'JURIDICA', '20601234567', 'Soluciones S.A.C.', 1, 'TRANSFERENCIA', '054823'),
(3, 'TS-E789B101', 7, 2, 3, '2026-07-08', '11:30:00', '45678912', 'Poder simple para representación natural.', 'REVISION', NOW(), NOW(), 'MEDIA', 'NATURAL', '45678912', 'Maria Lopez Lopez', 1, 'YAPE', '112233'),
(4, 'TS-F456C789', 8, 1, 1, '2026-07-08', '09:00:00', '32145678', 'Poder amplio y suficiente para cobro de pensión.', 'REDACCION', NOW(), NOW(), 'NORMAL', NULL, NULL, NULL, 1, 'TRANSFERENCIA', '998877'),
(5, 'TS-G321D654', 9, 2, 2, '2026-07-09', '10:30:00', '98765432', 'Representación de Inmobiliaria del Sur S.A.', 'SOLICITADO', NOW(), NOW(), 'ALTA', 'JURIDICA', '20556789012', 'Inmobiliaria del Sur S.A.', 1, 'YAPE', '445566'),
(6, 'TS-H987E321', 10, 1, 1, '2026-07-04', '12:00:00', '74185296', 'Poder para gestión de inmuebles y arrendamiento.', 'LISTO_FIRMA', DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), 'NORMAL', NULL, NULL, NULL, 1, 'YAPE', '012345'),
(7, 'TS-I123F456', 7, 1, 2, '2026-07-03', '11:00:00', '45678912', 'Poder corporativo para firma de contratos y licitaciones.', 'PROTOCOLIZACION', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), 'MEDIA', 'JURIDICA', '20112233445', 'Agroindustria del Norte EIRL', 1, 'TRANSFERENCIA', '112233'),
(8, 'TS-J789G101', 8, 2, 3, '2026-07-02', '09:30:00', '32145678', 'Poder simple para trámites ante la Sunarp.', 'ENTREGADO', DATE_SUB(NOW(), INTERVAL 6 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY), 'NORMAL', 'NATURAL', '32145678', 'Jose Perez Garcia', 1, 'YAPE', '998877'),
(9, 'TS-K456H789', 9, 1, 1, '2026-07-01', '10:00:00', '98765432', 'Poder cancelado por desistimiento de común acuerdo.', 'CANCELADO', DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY), 'NORMAL', NULL, NULL, NULL, 1, 'YAPE', '445566'),
(10, 'TS-L987I321', 10, 2, 2, '2026-07-07', '11:30:00', '74185296', 'Representación legal de Transporte Rápido S.A.', 'REVISION', DATE_SUB(NOW(), INTERVAL 1 DAY), NOW(), 'ALTA', 'JURIDICA', '20445566778', 'Transporte Rápido S.A.', 1, 'TRANSFERENCIA', '054823');
