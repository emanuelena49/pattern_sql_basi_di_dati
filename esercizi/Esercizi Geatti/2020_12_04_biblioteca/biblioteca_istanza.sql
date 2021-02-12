insert into socio values
('AA1111111','Ulderico Cavalli','M'),
('BB2222222','Clotilde Bianchi','F'),
('CC3333333','Ellade Pedone','M'),
('DD4444444','Ignazio Torre','M'),
('EE5555555','Regina Neri','F'),
('FF6666666','Germana Alfieri','F');

insert into genere values
('giallo','A'),
('orrore','A'),
('poesia','B');

insert into libro values
('88-11-11111-1','Il cane dei Baskerville','A. C. Doyle','giallo'),
('88-22-22222-2','I delitti della Rue Morgue','E. A. Poe','giallo'),
('88-33-33333-3','La bottiglia di Amontillado','E. A. Poe','orrore'),
('88-44-44444-4','Il gatto nero','E. A. Poe','orrore'),
('88-55-55555-5','Ossi di seppia','E. Montale','poesia'),
('88-66-66666-6','A ciascuno il suo','L. Sciascia','giallo'),
('88-77-77777-7','Canti','G. Leopardi','poesia'),
('88-88-88888-8','Finzioni','L. Borges',null);

insert into ha_letto values
('CC3333333','88-11-11111-1'),
('CC3333333','88-33-33333-3'),
('FF6666666','88-33-33333-3'),
('BB2222222','88-77-77777-7'),
('BB2222222','88-55-55555-5'),
('AA1111111','88-88-88888-8');

