use universidad;
/*1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. 
El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.*/
select apellido1, apellido2, nombre from persona where tipo = 'alumno' order by apellido1 asc, apellido2 asc, nombre asc;
/*2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.*/
select nombre, apellido1, apellido2 from persona where tipo = 'alumno' and telefono is null;
/*3. Retorna el llistat dels alumnes que van néixer en 1999.*/
select * from persona where tipo = 'alumno' and fecha_nacimiento like '1999%';
/*4. Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.*/
select * from persona where tipo = 'profesor' and telefono is null and nif like '%K';
/*5. Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.*/
select * from asignatura where cuatrimestre = 1 and curso = 3 and id_grado = 7;
/*6. Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. 
El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. 
El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.*/
select persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre as 'departamento' from persona, departamento, profesor where persona.tipo = 'profesor' and profesor.id_profesor = persona.id and departamento.id = profesor.id_departamento;
/*7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.*/
select nombre, anyo_inicio, anyo_fin from asignatura, curso_escolar, alumno_se_matricula_asignatura where id_alumno in (select id from persona where nif = '26902806M') and asignatura.id = alumno_se_matricula_asignatura.id_asignatura and curso_escolar.id = id_curso_escolar;
/*8. Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).*/
select nombre from departamento where id in (select id_departamento from profesor where id_profesor in (select distinct id_profesor from asignatura where id_grado in (select id from grado where nombre like 'Grado en Ingeniería Informática (Plan 2015)')  and id_profesor is not null));
/*9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.*/
select * from persona where id in (select id_alumno from alumno_se_matricula_asignatura where id_curso_escolar in (select id from curso_escolar where anyo_inicio = '2018'));
/*Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.*/
/* 1. Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. 
El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. 
El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. 
El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.*/
select departamento.nombre as 'nombre_departamento', persona.nombre, persona.apellido1, persona.apellido2 from profesor left join departamento on profesor.id_departamento = departamento.id left join persona on profesor.id_profesor = persona.id order by departamento.nombre ASC, persona.apellido1 ASC, persona.apellido2 ASC, persona.nombre ASC;
/*2. Retorna un llistat amb els professors/es que no estan associats a un departament.*/
select * from profesor left join persona on profesor.id_profesor = persona.id where profesor.id_departamento is null;
/*3. Retorna un llistat amb els departaments que no tenen professors/es associats.*/
select * from departamento left join profesor on profesor.id_departamento = departamento.id where profesor.id_departamento is null;
/*4. Retorna un llistat amb els professors/es que no imparteixen cap assignatura.*/
select distinct id_profesor from asignatura;
select * from persona left join asignatura on asignatura.id_profesor = persona.id where asignatura.id_profesor is null and persona.tipo = 'profesor';
/*5. Retorna un llistat amb les assignatures que no tenen un professor/a assignat.*/
select nombre from asignatura where id_profesor is null;
select asignatura.nombre from asignatura left join persona on asignatura.id_profesor = persona.id where asignatura.id_profesor is null;
/*6. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.*/
select distinct departamento.nombre from profesor left join asignatura on asignatura.id_profesor = profesor.id_profesor left join departamento on departamento.id = profesor.id_departamento where asignatura.id is null;
/*Consultes resum:
1. Retorna el nombre total d'alumnes que hi ha.*/
select count(id) as 'numero total de alumnos' from persona where tipo = 'alumno';
/*2.Calcula quants alumnes van néixer en 1999.*/
select count(id) as 'numero de alumnos nacidos en 1999' from persona where tipo = 'alumno' and fecha_nacimiento like '1999%';
/*3.alcula quants professors/es hi ha en cada departament. 
El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es 
que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats 
i haurà d'estar ordenat de major a menor pel nombre de professors/es.*/
select id_departamento, count(id_profesor) from profesor left join departamento on departamento.id = profesor.id_departamento where departamento.nombre like 'Agronomía';
select departamento.nombre, count(*) profesores from departamento left join profesor on departamento.id = profesor.id_departamento group by departamento.nombre order by count(*) desc;
/*4.Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. 
Tingui en compte que poden existir departaments que no tenen professors/es associats. 
Aquests departaments també han d'aparèixer en el llistat.*/
select departamento.nombre, count(profesor.id_profesor) profesores from departamento left join profesor on id_departamento = departamento.id;
/* select de profesores por departamento */
select nombre, count(id_profesor) profesores from departamento, profesor where id = id_departamento group by nombre;
/*5.Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. 
Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. 
El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.*/
select grado.nombre, count(asignatura.nombre) asignaturas from grado left join asignatura on grado.id = asignatura.id_grado group by grado.nombre order by count(*) desc;
/*6.Retorna un llistat amb el nom de tots els graus existents en la base de dades i 
el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.*/
select grado.nombre, count(asignatura.nombre) asignaturas from grado left join asignatura on grado.id = asignatura.id_grado group by grado.nombre having count(*) > 40 order by count(*) desc;
/*7.Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. 
El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura 
i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.*/
select grado.nombre, asignatura.tipo, sum(asignatura.creditos) creditos from grado, asignatura where grado.id = asignatura.id_grado group by grado.nombre, asignatura.tipo;
/*8. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. 
El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.*/
select curso_escolar.anyo_inicio, sum(alumno_se_matricula_asignatura.id_alumno) alumnos from curso_escolar, alumno_se_matricula_asignatura where curso_escolar.id = alumno_se_matricula_asignatura.id_curso_escolar group by curso_escolar.anyo_inicio;
/*9. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. 
El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. 
El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. 
El resultat estarà ordenat de major a menor pel nombre d'assignatures.*/
select id, nombre, apellido1, apellido2 from persona;
select count(id) from asignatura where id_profesor = 14;
select id, id_profesor from asignatura;
select a.id, a.nombre, a.apellido1, a.apellido2, count(b.id) asignaturas from persona a, asignatura b where a.id = b.id_profesor group by b.id_profesor order by count(b.id) asc;
/*10.Retorna totes les dades de l'alumne/a més jove.*/
select * from persona where tipo = 'alumno' order by fecha_nacimiento desc limit 1;
/*11.Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.*/
select a.id, a.nombre, a.apellido1, a.apellido2, b.id_departamento from persona a, profesor b where a.id = b.id_profesor and id not in (select id_profesor from asignatura where a.id = asignatura.id_profesor) group by a.id;
