SELECT apellido1, apellido2, nombre FROM persona WHERE tipo = "alumno" ORDER BY apellido1, apellido2, nombre;
SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo = "alumno" AND telefono IS NULL;
SELECT nombre, apellido1, apellido2, fecha_nacimiento FROM persona WHERE tipo = "alumno" AND year(fecha_nacimiento) = 1999;
SELECT * FROM persona WHERE tipo = "profesor" AND telefono IS NULL AND RIGHT(nif, 1) = "K";
SELECT * FROM asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS "departamento" FROM profesor pr JOIN persona p ON pr.id_profesor = p.id JOIN departamento d ON pr.id_departamento = d.id ORDER BY p.apellido1, p.apellido2, p.nombre;
SELECT a.nombre AS asignatura, ce.anyo_inicio, ce.anyo_fin FROM alumno_se_matricula_asignatura am JOIN asignatura a ON am.id_asignatura = a.id JOIN curso_escolar ce ON am.id_curso_escolar = ce.id JOIN persona p ON am.id_alumno = p.id WHERE p.nif = "26902806M";
SELECT DISTINCT d.nombre FROM departamento d JOIN profesor p ON d.id = p.id_departamento JOIN persona pe ON p.id_profesor = pe.id JOIN asignatura a ON pe.id = a.id_profesor JOIN grado g ON a.id_grado = g.id WHERE g.nombre = "Grado en Ingeniería Informática (Plan 2015)";
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2 FROM persona p JOIN alumno_se_matricula_asignatura am ON p.id = am.id_alumno JOIN curso_escolar ce ON am.id_curso_escolar = ce.id WHERE ce.anyo_inicio = 2018 AND ce.anyo_fin = 2019;
-- LEFT JOIN I RIGHT JOIN
SELECT d.nombre as "departamento", p.apellido1, p.apellido2, p.nombre FROM persona p LEFT JOIN profesor pr ON p.id = pr.id_profesor LEFT JOIN departamento d ON d.id = pr.id_departamento WHERE p.tipo = "profesor" ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre;
SELECT p.id, p.apellido1, p.apellido2, p.nombre FROM persona p LEFT JOIN profesor pr ON p.id = pr.id_profesor LEFT JOIN departamento d ON pr.id_departamento = d.id WHERE p.tipo = 'profesor' AND pr.id_departamento IS NULL ORDER BY p.apellido1, p.apellido2, p.nombre;
SELECT d.nombre FROM departamento d LEFT JOIN profesor pr ON d.id = pr.id_departamento WHERE pr.id_departamento IS NULL;
SELECT p.nombre, p.apellido1 FROM persona p LEFT JOIN profesor pr ON pr.id_profesor = p.id LEFT JOIN asignatura a ON a.id_profesor = pr.id_profesor WHERE a.nombre IS NULL ORDER BY p.nombre;
SELECT a.nombre AS asignatura FROM asignatura a LEFT JOIN profesor pr ON pr.id_profesor = a.id_profesor WHERE a.id_profesor IS NULL ORDER BY a.nombre;
SELECT d.nombre AS departamento FROM departamento d LEFT JOIN profesor pr ON d.id = pr.id_departamento LEFT JOIN asignatura a ON a.id_profesor = pr.id_profesor WHERE a.curso IS NULL;
-- RESUM
SELECT COUNT(*) AS num_alumnos FROM persona WHERE tipo = "alumno";
SELECT COUNT(*) AS num_alumnos_1999 FROM persona WHERE YEAR(fecha_nacimiento) = 1999 AND tipo = "alumno";
SELECT d.nombre AS "departamento", COUNT(pr.id_profesor)  AS num_profesores FROM departamento d LEFT JOIN profesor pr ON pr.id_departamento = d.id WHERE pr.id_departamento IS NOT NULL GROUP BY d.nombre ORDER BY num_profesores DESC;
SELECT d.nombre AS "departamento", COUNT(pr.id_profesor)  AS num_profesores FROM departamento d LEFT JOIN profesor pr ON pr.id_departamento = d.id GROUP BY d.nombre;
SELECT g.nombre, COUNT(a.id) AS num_asignaturas FROM grado g LEFT JOIN asignatura a ON g.id = a.id_grado GROUP BY g.nombre ORDER BY num_asignaturas DESC;
SELECT g.nombre, COUNT(a.id) AS num_asignaturas FROM grado g LEFT JOIN asignatura a ON g.id = a.id_grado GROUP BY g.nombre HAVING COUNT(a.id) > 40;
SELECT g.nombre AS nombre_grado, a.tipo AS tipo_asignatura, SUM(a.creditos) AS suma_creditos FROM grado g LEFT JOIN asignatura a ON g.id = a.id_grado GROUP BY g.nombre, a.tipo;
SELECT ce.anyo_inicio AS curso, COUNT(DISTINCT am.id_alumno) AS num_alumnos_matriculados FROM curso_escolar ce LEFT JOIN alumno_se_matricula_asignatura am ON ce.id = am.id_curso_escolar GROUP BY ce.anyo_inicio;
SELECT pr.id_profesor, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS num_asignaturas FROM profesor pr LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor LEFT JOIN persona p ON pr.id_profesor = p.id WHERE p.tipo = "profesor" GROUP BY pr.id_profesor ORDER BY num_asignaturas DESC;
SELECT pr.id_profesor, p.nombre, p.apellido1, p.apellido2, COUNT(a.id_profesor) AS num_asignaturas FROM asignatura a RIGHT JOIN profesor pr ON a.id_profesor = pr.id_profesor JOIN persona p ON pr.id_profesor = p.id GROUP BY pr.id_profesor ORDER BY count(pr.id_profesor) DESC;
SELECT * FROM persona WHERE tipo = "alumno" ORDER BY fecha_nacimiento ASC LIMIT 1;
SELECT CONCAT(p.apellido1, " ", p.apellido2, ", ", p.nombre) AS nombre_profesor FROM profesor pr JOIN persona p ON pr.id_profesor = p.id LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor WHERE pr.id_departamento IS NOT NULL AND a.id IS NULL;