DROP DATABASE IF EXISTS `copado_mundo`;
CREATE DATABASE IF NOT EXISTS `copado_mundo` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `copado_mundo`;

-- 1. TABELA DE SELEÇÕES
CREATE TABLE `selecao` (
  `id_selecao` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) DEFAULT NULL,
  `grupo` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id_selecao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. TABELA DE JOGADORES
CREATE TABLE `jogador` (
  `id_jogador` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) DEFAULT NULL,
  `posicao` VARCHAR(100) DEFAULT NULL,
  `id_selecao_fk` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id_jogador`),
  KEY `id_selecao_fk` (`id_selecao_fk`),
  CONSTRAINT `jogador_ibfk_1` FOREIGN KEY (`id_selecao_fk`) REFERENCES `selecao` (`id_selecao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 3. TABELA DE PARTIDAS
CREATE TABLE `partidas` (
  `id_partidas` INT(11) NOT NULL AUTO_INCREMENT,
  `data` TEXT NOT NULL,
  `id_selecao_casa_fk` INT(11) NOT NULL,
  `id_selecao_visitante_fk` INT(11) NOT NULL,
  `placar_casa` INT(11) DEFAULT NULL,
  `placar_visitante` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id_partidas`),
  KEY `id_selecao_casa_fk` (`id_selecao_casa_fk`),
  KEY `id_selecao_visitante_fk` (`id_selecao_visitante_fk`),
  CONSTRAINT `partidas_ibfk_1` FOREIGN KEY (`id_selecao_casa_fk`) REFERENCES `selecao` (`id_selecao`),
  CONSTRAINT `partidas_ibfk_2` FOREIGN KEY (`id_selecao_visitante_fk`) REFERENCES `selecao` (`id_selecao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 4. TABELA DE USUÁRIOS (Login e Cadastro)
CREATE TABLE `usuario` (
  `id_usuario` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `senha` VARCHAR(255) NOT NULL,
  `pergunta_seguranca` VARCHAR(255) NOT NULL,
  `resposta_seguranca` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Carga inicial de Seleções (Exemplos)
INSERT INTO `selecao` (`id_selecao`, `nome`, `grupo`) VALUES
(1, 'México', 'Grupo A'), (2, 'África do Sul', 'Grupo A'), (3, 'Coreia do Sul', 'Grupo A'), (4, 'República Tcheca', 'Grupo A'),
(5, 'Canadá', 'Grupo B'), (6, 'Bósnia e Herzegovina', 'Grupo B'), (7, 'Catar', 'Grupo B'), (8, 'Suíça', 'Grupo B'),
(9, 'Brasil', 'Grupo C'), (10, 'Marrocos', 'Grupo C'), (11, 'Haiti', 'Grupo C'), (12, 'Escócia', 'Grupo C'),
(13, 'Estados Unidos', 'Grupo D'), (14, 'Paraguai', 'Grupo D'), (15, 'Austrália', 'Grupo D'), (16, 'Turquia', 'Grupo D'),
(17, 'Alemanha', 'Grupo E'), (18, 'Curaçao', 'Grupo E'), (19, 'Costa do Marfim', 'Grupo E'), (20, 'Equador', 'Grupo E'),
(21, 'Holanda', 'Grupo F'), (22, 'Japão', 'Grupo F'), (23, 'Suécia', 'Grupo F'), (24, 'Tunísia', 'Grupo F'),
(25, 'Bélgica', 'Grupo G'), (26, 'Egito', 'Grupo G'), (27, 'Irã', 'Grupo G'), (28, 'Nova Zelândia', 'Grupo G'),
(29, 'Espanha', 'Grupo H'), (30, 'Cabo Verde', 'Grupo H'), (31, 'Arábia Saudita', 'Grupo H'), (32, 'Uruguai', 'Grupo H'),
(33, 'França', 'Grupo I'), (34, 'Senegal', 'Grupo I'), (35, 'Iraque', 'Grupo I'), (36, 'Noruega', 'Grupo I'),
(37, 'Argentina', 'Grupo J'), (38, 'Argélia', 'Grupo J'), (39, 'Áustria', 'Grupo J'), (40, 'Jordânia', 'Grupo J'),
(41, 'Portugal', 'Grupo K'), (42, 'RD Congo', 'Grupo K'), (43, 'Uzbequistão', 'Grupo K'), (44, 'Colômbia', 'Grupo K'),
(45, 'Inglaterra', 'Grupo L'), (46, 'Croácia', 'Grupo L'), (47, 'Gana', 'Grupo L'), (48, 'Panamá', 'Grupo L');

-- Carga inicial de Jogadores (Exemplos)
INSERT INTO `jogador` (`nome`, `posicao`, `id_selecao_fk`) VALUES
-- México (id_selecao: 1)
('Luis Malagón', 'Goleiro', 1), ('Johan Vásquez', 'Defensor', 1), ('Jorge Sánchez', 'Defensor', 1), ('César Montes', 'Defensor', 1), ('Jesús Gallardo', 'Defensor', 1),
('Israel Reyes', 'Defensor', 1), ('Diego Lainez', 'Meio-campo', 1), ('Carlos Rodríguez', 'Meio-campo', 1), ('Edson Álvarez', 'Meio-campo', 1), ('Orbelín Pineda', 'Meio-campo', 1),
('Marcel Ruiz', 'Meio-campo', 1), ('Érick Sánchez', 'Meio-campo', 1), ('Hirving Lozano', 'Atacante', 1), ('Santiago Giménez', 'Atacante', 1), ('Raúl Jiménez', 'Atacante', 1),
('Alexis Vega', 'Atacante', 1), ('Roberto Alvarado', 'Atacante', 1), ('César Huerta', 'Atacante', 1),

-- África do Sul (id_selecao: 2)
('Ronwen Williams', 'Goleiro', 2), ('Sipho Chaine', 'Goleiro', 2), ('Aubrey Modiba', 'Defensor', 2), ('Samukele Kabini', 'Defensor', 2), ('Mbekezeli Mbokazi', 'Defensor', 2),
('Khulumani Ndamane', 'Defensor', 2), ('Siyabonga Ngezana', 'Defensor', 2), ('Khuliso Mudau', 'Defensor', 2), ('Nkosinathi Sibisi', 'Defensor', 2), ('Teboho Mokoena', 'Meio-campo', 2),
('Thalente Mbatha', 'Meio-campo', 2), ('Bathuisi Aubaas', 'Meio-campo', 2), ('Yaya Sithole', 'Meio-campo', 2), ('Sipho Mbule', 'Meio-campo', 2), ('Lyle Foster', 'Atacante', 2),
('Ioraam Rayners', 'Atacante', 2), ('Mohau Nkota', 'Atacante', 2), ('Oswin Appolis', 'Atacante', 2),

-- Coreia do Sul (id_selecao: 3)
('Hyeon-woo Jo', 'Goleiro', 3), ('Seung-Gyu Kim', 'Goleiro', 3), ('Min-jae Kim', 'Defensor', 3), ('Yu-min Cho', 'Defensor', 3), ('Young-woo Seol', 'Defensor', 3),
('Han-beom Lee', 'Defensor', 3), ('Tae-seok Lee', 'Defensor', 3), ('Myung-jae Lee', 'Defensor', 3), ('Jae-sung Lee', 'Meio-campo', 3), ('In-beom Hwang', 'Meio-campo', 3),
('Kang-in Lee', 'Meio-campo', 3), ('Seung-ho Paik', 'Meio-campo', 3), ('Jens Castrop', 'Meio-campo', 3), ('Dong-gyeong Lee', 'Meio-campo', 3), ('Gue-sung Cho', 'Atacante', 3),
('Heung-min Son', 'Atacante', 3), ('Hee-chan Hwang', 'Atacante', 3), ('Hyeon-Gyu Oh', 'Atacante', 3),

-- República Tcheca (id_selecao: 4)
('Matěj Kovář', 'Goleiro', 4), ('Jindřich Staněk', 'Goleiro', 4), ('Ladislav Krejčí', 'Defensor', 4), ('Vladimír Coufal', 'Defensor', 4), ('Jaroslav Zelený', 'Defensor', 4),
('Tomáš Holeš', 'Defensor', 4), ('David Zima', 'Defensor', 4), ('Michal Sadílek', 'Meio-campo', 4), ('Lukáš Provod', 'Meio-campo', 4), ('Lukáš Červ', 'Meio-campo', 4),
('Tomáš Souček', 'Meio-campo', 4), ('Pavel Šulc', 'Meio-campo', 4), ('Matěj Vydra', 'Atacante', 4), ('Vasil Kušej', 'Atacante', 4), ('Tomáš Chorý', 'Atacante', 4),
('Václav Černý', 'Atacante', 4), ('Adam Hložek', 'Atacante', 4), ('Patrik Schick', 'Atacante', 4),

-- Canadá (id_selecao: 5)
('Dayne St. Clair', 'Goleiro', 5), ('Alphonso Davies', 'Defensor', 5), ('Alistair Johnston', 'Defensor', 5), ('Samuel Adekugbe', 'Defensor', 5), ('Richie Laryea', 'Defensor', 5),
('Derek Cornelius', 'Defensor', 5), ('Moïse Bombito', 'Defensor', 5), ('Kamal Miller', 'Defensor', 5), ('Stephen Eustáquio', 'Meio-campo', 5), ('Ismaël Koné', 'Meio-campo', 5),
('Jonathan Osorio', 'Meio-campo', 5), ('Jacob Shaffelburg', 'Meio-campo', 5), ('Mathieu Choinière', 'Meio-campo', 5), ('Niko Sigur', 'Meio-campo', 5), ('Tajon Buchanan', 'Atacante', 5),
('Liam Millar', 'Atacante', 5), ('Cyle Larin', 'Atacante', 5), ('Jonathan David', 'Atacante', 5),

-- Bósnia e Herzegovina (id_selecao: 6)
('Nikola Vasilj', 'Goleiro', 6), ('Amar Dedić', 'Defensor', 6), ('Sead Kolašinac', 'Defensor', 6), ('Tarik Muharemović', 'Defensor', 6), ('Nihad Mujakić', 'Defensor', 6),
('Nikola Katić', 'Defensor', 6), ('Amir Hadžiahmetović', 'Meio-campo', 6), ('Benjamin Tahirović', 'Meio-campo', 6), ('Armin Gigović', 'Meio-campo', 6), ('Ivan Šunjić', 'Meio-campo', 6),
('Ivan Bašić', 'Meio-campo', 6), ('Dženis Burnić', 'Meio-campo', 6), ('Esmir Bajraktarević', 'Atacante', 6), ('Amar Memić', 'Atacante', 6), ('Ermedin Demirović', 'Atacante', 6),
('Edin Džeko', 'Atacante', 6), ('Samed Baždar', 'Atacante', 6), ('Haris Tabaković', 'Atacante', 6),

-- Catar (id_selecao: 7)
('Meshaal Barsham', 'Goleiro', 7), ('Sultan Albrake', 'Defensor', 7), ('Lucas Mendes', 'Defensor', 7), ('Homam Ahmed', 'Defensor', 7), ('Boualem Khoukhi', 'Defensor', 7),
('Pedro Miguel', 'Defensor', 7), ('Tarek Salman', 'Defensor', 7), ('Mohamed Al-Mannai', 'Meio-campo', 7), ('Karim Boudiaf', 'Meio-campo', 7), ('Assim Madibo', 'Meio-campo', 7),
('Ahmed Fatehi', 'Meio-campo', 7), ('Mohammed Waad', 'Meio-campo', 7), ('Abdulaziz Hatem', 'Meio-campo', 7), ('Hassan Al-Haydos', 'Meio-campo', 7), ('Edmilson Junior', 'Atacante', 7),
('Akram Hassan Afif', 'Atacante', 7), ('Ahmed Al Ganehi', 'Atacante', 7), ('Almoez Ali', 'Atacante', 7),

-- Suíça (id_selecao: 8)
('Gregor Kobel', 'Goleiro', 8), ('Yvon Mvogo', 'Goleiro', 8), ('Manuel Akanji', 'Defensor', 8), ('Ricardo Rodriguez', 'Defensor', 8), ('Nico Elvedi', 'Defensor', 8),
('Aurèle Amenda', 'Defensor', 8), ('Silvan Widmer', 'Defensor', 8), ('Granit Xhaka', 'Meio-campo', 8), ('Denis Zakaria', 'Meio-campo', 8), ('Remo Freuler', 'Meio-campo', 8),
('Fabian Rieder', 'Meio-campo', 8), ('Ardon Jashari', 'Meio-campo', 8), ('Johan Manzambi', 'Meio-campo', 8), ('Michel Aebischer', 'Meio-campo', 8), ('Breel Embolo', 'Atacante', 8),
('Ruben Vargas', 'Atacante', 8), ('Dan Ndoye', 'Atacante', 8), ('Zeki Amdouni', 'Atacante', 8),

-- Brasil (id_selecao: 9)
('Alisson', 'Goleiro', 9), ('Bento', 'Goleiro', 9), ('Marquinhos', 'Defensor', 9), ('Éder Militão', 'Defensor', 9), ('Gabriel Magalhães', 'Defensor', 9),
('Danilo', 'Defensor', 9), ('Wesley', 'Defensor', 9), ('Lucas Paquetá', 'Meio-campo', 9), ('Casemiro', 'Meio-campo', 9), ('Bruno Guimarães', 'Meio-campo', 9),
('Luiz Henrique', 'Atacante', 9), ('Vinícius Júnior', 'Atacante', 9), ('Rodrygo', 'Atacante', 9), ('João Pedro', 'Atacante', 9), ('Matheus Cunha', 'Atacante', 9),
('Gabriel Martinelli', 'Atacante', 9), ('Raphinha', 'Atacante', 9), ('Estêvão', 'Atacante', 9),

-- Marrocos (id_selecao: 10)
('Yassine Bounou', 'Goleiro', 10), ('Munir El Kajoui', 'Goleiro', 10), ('Achraf Hakimi', 'Defensor', 10), ('Noussair Mazraoui', 'Defensor', 10), ('Nayef Aguerd', 'Defensor', 10),
('Romain Saïss', 'Defensor', 10), ('Jawad El Yamiq', 'Defensor', 10), ('Adam Masina', 'Defensor', 10), ('Sofyan Amrabat', 'Meio-campo', 10), ('Azzedine Ounahi', 'Meio-campo', 10),
('Eliesse Ben Seghir', 'Meio-campo', 10), ('Bilal El Khannouss', 'Meio-campo', 10), ('Ismael Saibari', 'Meio-campo', 10), ('Youssef En-Nesyri', 'Atacante', 10), ('Abde Ezzalzouli', 'Atacante', 10),
('Soufiane Rahimi', 'Atacante', 10), ('Brahim Díaz', 'Atacante', 10), ('Ayoub El Kaabi', 'Atacante', 10),

-- Haiti (id_selecao: 11)
('Johny Placide', 'Goleiro', 11), ('Carlens Arcus', 'Defensor', 11), ('Martin Expérience', 'Defensor', 11), ('Jean-Kevin Duverne', 'Defensor', 11), ('Ricardo Adé', 'Defensor', 11),
('Duke Lacroix', 'Defensor', 11), ('Garven Metusala', 'Defensor', 11), ('Hannes Delcroix', 'Defensor', 11), ('Leverton Pierre', 'Meio-campo', 11), ('Danley Jean Jacques', 'Meio-campo', 11),
('Jean-Ricner Bellegarde', 'Meio-campo', 11), ('Christopher Attys', 'Meio-campo', 11), ('Derrick Etienne Jr.', 'Atacante', 11), ('Josué Casimir', 'Atacante', 11), ('Ruben Providence', 'Atacante', 11),
('Duckens Nazon', 'Atacante', 11), ('Louicius Deedson', 'Atacante', 11), ('Frantzdy Pierrot', 'Atacante', 11),

-- Escócia (id_selecao: 12)
('Angus Gunn', 'Goleiro', 12), ('Jack Hendry', 'Defensor', 12), ('Kieran Tierney', 'Defensor', 12), ('Aaron Hickey', 'Defensor', 12), ('Andrew Robertson', 'Defensor', 12),
('Scott McKenna', 'Defensor', 12), ('John Souttar', 'Defensor', 12), ('Anthony Ralston', 'Defensor', 12), ('Grant Hanley', 'Defensor', 12), ('Scott McTominay', 'Meio-campo', 12),
('Billy GilmourLewis', 'Meio-campo', 12), ('Ferguson', 'Meio-campo', 12), ('Ryan Christie', 'Meio-campo', 12), ('Kenny McLean', 'Meio-campo', 12), ('John McGinn', 'Meio-campo', 12),
('Lyndon Dykes', 'Atacante', 12), ('Che Adams', 'Atacante', 12), ('Ben Gannon-Doak', 'Atacante', 12),

-- Estados Unidos (id_selecao: 13)
('Math Freese', 'Goleiro', 13), ('Chris Richards', 'Defensor', 13), ('Tim Ream', 'Defensor', 13), ('Mark McKenzie', 'Defensor', 13), ('Alex Freeman', 'Defensor', 13),
('Antonee Robinson', 'Defensor', 13), ('Tyler Adams', 'Meio-campo', 13), ('Tanner Tessmann', 'Meio-campo', 13), ('Weston McKenny', 'Meio-campo', 13), ('Christian Roldan', 'Meio-campo', 13),
('Timothy Weah', 'Atacante', 13), ('Diego Luna', 'Atacante', 13), ('Malim Tillman', 'Atacante', 13), ('Christian Pulisic', 'Atacante', 13), ('Brenden Aaronson', 'Atacante', 13),
('Ricardo Pepi', 'Atacante', 13), ('Haji Wright', 'Atacante', 13), ('Folarin Balogun', 'Atacante', 13),

-- Paraguai (id_selecao: 14)
('Roberto Fernández', 'Goleiro', 14), ('Orlando Gill', 'Goleiro', 14), ('Gustavo Gómez', 'Defensor', 14), ('Fabián Balbuena', 'Defensor', 14), ('Juan José Cáceres', 'Defensor', 14),
('Omar Alderete', 'Defensor', 14), ('Junior Alonso', 'Defensor', 14), ('Mathías Villasanti', 'Meio-campo', 14), ('Diego Gómez', 'Meio-campo', 14), ('Damián Bobadilla', 'Meio-campo', 14),
('Andrés Cubas', 'Meio-campo', 14), ('Matías Galarza Fonda', 'Meio-campo', 14), ('Julio Enciso', 'Atacante', 14),

-- Austrália (id_selecao: 15)
('Mathew Ryan', 'Goleiro', 15), ('Joe Gauci', 'Goleiro', 15), ('Harry Souttar', 'Defensor', 15), ('Alessandro Circati', 'Defensor', 15), ('Jordan Bos', 'Defensor', 15),
('Aziz Behich', 'Defensor', 15), ('Cameron Burgess', 'Defensor', 15), ('Lewis Miller', 'Defensor', 15), ('Milos Degenek', 'Defensor', 15), ('Jackson Irvine', 'Meio-campo', 15),
('Riley McGree', 'Meio-campo', 15), ('Aiden O’Neill', 'Meio-campo', 15), ('Connor Metcalfe', 'Meio-campo', 15), ('Patrick Yazbek', 'Meio-campo', 15), ('Craig Goodwin', 'Atacante', 15),
('Kusini Yengi', 'Atacante', 15), ('Nestory Irankunda', 'Atacante', 15), ('Mohamed Touré', 'Atacante', 15),

-- Turquia (id_selecao: 16)
('Ugurcan Cakir', 'Goleiro', 16), ('Mert Muldur', 'Defensor', 16), ('Zeki Celik', 'Defensor', 16), ('Abdulkerim Bardakci', 'Defensor', 16), ('Caglar Soyunku', 'Defensor', 16),
('Merih Demiral', 'Defensor', 16), ('Ferdi Kadioglu', 'Defensor', 16), ('Kaan Ayhan', 'Meio-campo', 16), ('Ismail Yuksek', 'Meio-campo', 16), ('Hakan Calhanoglu', 'Meio-campo', 16),
('Orkun Kokcu', 'Meio-campo', 16), ('Arda Güler', 'Meio-campo', 16), ('Irfan Can Kahvecu', 'Meio-campo', 16), ('Yunus Akgun', 'Atacante', 16), ('Can Uzun', 'Atacante', 16),
('Baris Alper Yilmaz', 'Atacante', 16), ('Kerem Akturkoglu', 'Atacante', 16), ('Kenan Yildiz', 'Atacante', 16),

-- Alemanha (id_selecao: 17)
('Marc-André ter Stegen', 'Goleiro', 17), ('Jonathan Tah', 'Defensor', 17), ('David Raum', 'Defensor', 17), ('Nico Schlotterbeck', 'Defensor', 17), ('Antonio Rüdiger', 'Defensor', 17),
('Waldemar Anton', 'Defensor', 17), ('Ridle Baku', 'Defensor', 17), ('Maximilian Mittelstädt', 'Defensor', 17), ('Joshua Kimmich', 'Meio-campo', 17), ('Florian Wirtz', 'Meio-campo', 17),
('Felix Nmecha', 'Meio-campo', 17), ('Leon Goretzka', 'Meio-campo', 17), ('Jamal Musiala', 'Meio-campo', 17), ('Serge Gnabry', 'Atacante', 17), ('Kai Havertz', 'Atacante', 17),
('Leroy Sané', 'Atacante', 17), ('Karim Adeyemi', 'Atacante', 17), ('Nick Woltemade', 'Atacante', 17),

-- Curaçao (id_selecao: 18)
('Eloy Room', 'Goleiro', 18), ('Armando Obispo', 'Defensor', 18), ('Sherel Floranus', 'Defensor', 18), ('Jurien Gaari', 'Defensor', 18), ('Joshua Brenet', 'Defensor', 18),
('Roshon Van Eijma', 'Defensor', 18), ('Shurandy Sambo', 'Defensor', 18), ('Livano Comenencia', 'Meio-campo', 18), ('Godfried Roemeratoe', 'Meio-campo', 18), ('Juninho Bacuna', 'Meio-campo', 18),
('Leandro Bacuna', 'Meio-campo', 18), ('Tahith Chong', 'Meio-campo', 18), ('Kenji Gorré', 'Atacante', 18), ('Jearl Margaritha', 'Atacante', 18), ('Jurgen Locadia', 'Atacante', 18),
('Jeremy Antonisse', 'Atacante', 18), ('Gervane Kastaneer', 'Atacante', 18), ('Sontje Hansen', 'Atacante', 18),

-- Costa do Marfim (id_selecao: 19)
('Yahia Fofana', 'Goleiro', 19), ('Ghislain Konan', 'Defensor', 19), ('Wilfried Singo', 'Defensor', 19), ('Odilon Kossounou', 'Defensor', 19), ('Evan Ndicka', 'Defensor', 19),
('Willy Boly', 'Defensor', 19), ('Emmanuel Agbadou', 'Defensor', 19), ('Ousmane Diomande', 'Defensor', 19), ('Franck Kessié', 'Meio-campo', 19), ('Seko Fofana', 'Meio-campo', 19),
('Ibrahim Sangaré', 'Meio-campo', 19), ('Jean-Philippe Gbamin', 'Meio-campo', 19), ('Amad Diallo', 'Atacante', 19), ('Sébastien Haller', 'Atacante', 19), ('Simon Adingra', 'Atacante', 19),
('Yan Diomande', 'Atacante', 19), ('Evann Guessand', 'Atacante', 19), ('Oumar Diakité', 'Atacante', 19),

-- Equador (id_selecao: 20)
('Hernán Galíndez', 'Goleiro', 20), ('Gonzalo Valle', 'Goleiro', 20), ('Piero Hincapié', 'Defensor', 20), ('Pervis Estupiñán', 'Defensor', 20), ('Willian Pacho', 'Defensor', 20),
('Ángelo Preciado', 'Defensor', 20), ('Joel Ordóñez', 'Defensor', 20), ('Moisés Caicedo', 'Meio-campo', 20), ('Alan Franco', 'Meio-campo', 20), ('Kendry Páez', 'Meio-campo', 20),
('Pedro Vite', 'Meio-campo', 20), ('John Veboah', 'Meio-campo', 20), ('Leonardo Campana', 'Atacante', 20), ('Gonzalo Plata', 'Atacante', 20), ('Nilson Angulo', 'Atacante', 20),
('Alan Minda', 'Atacante', 20), ('Kevin Rodríguez', 'Atacante', 20), ('Enner Valencia', 'Atacante', 20),

-- Holanda (id_selecao: 21)
('Bart Verbruggen', 'Goleiro', 21), ('Virgil van Dijk', 'Defensor', 21), ('Micky van de Ven', 'Defensor', 21), ('Jurriën Timber', 'Defensor', 21), ('Denzel Dumfries', 'Defensor', 21),
('Nathan Aké', 'Defensor', 21), ('Jeremie Frimpong', 'Defensor', 21), ('Jan Paul van Hecke', 'Defensor', 21), ('Tijjani Reijnders', 'Meio-campo', 21), ('Ryan Gravenberch', 'Meio-campo', 21),
('Teun Koopmeiners', 'Meio-campo', 21), ('Frenkie de Jong', 'Meio-campo', 21), ('Xavi Simons', 'Meio-campo', 21), ('Justin Kluivert', 'Atacante', 21), ('Memphis Depay', 'Atacante', 21),
('Donyell Malen', 'Atacante', 21), ('Wout Weghorst', 'Atacante', 21), ('Cody Gakpo', 'Atacante', 21),

-- Japão (id_selecao: 22)
('Zion Suzuki', 'Goleiro', 22), ('Henry Heroki Mochizuki', 'Defensor', 22), ('Ayumu Seko', 'Defensor', 22), ('Junnosuke Suzuki', 'Defensor', 22), ('Shogo Taniguchi', 'Defensor', 22),
('Tsuyoshi Watanabe', 'Defensor', 22), ('Kaishu Sano', 'Meio-campo', 22), ('Yuki Soma', 'Meio-campo', 22), ('Ao Tanaka', 'Meio-campo', 22), ('Daichi Kamada', 'Meio-campo', 22),
('Takefusa Kubo', 'Meio-campo', 22), ('Ritsu Doan', 'Meio-campo', 22), ('Keito Nakamura', 'Meio-campo', 22), ('Takumi Minamino', 'Meio-campo', 22), ('Shuto Machino', 'Atacante', 22),
('Junya Ito', 'Atacante', 22), ('Koki Ogawa', 'Atacante', 22), ('Ayase Ueda', 'Atacante', 22),

-- Suécia (id_selecao: 23)
('Victor Johansson', 'Goleiro', 23), ('Isak Hien', 'Defensor', 23), ('Gabriel Gudmundsson', 'Defensor', 23), ('Emil Holm', 'Defensor', 23), ('Victor Nilsson Lindelöf', 'Defensor', 23),
('Gustaf Lagerbielke', 'Defensor', 23), ('Lucas Bergvall', 'Meio-campo', 23), ('Hugo Larsson', 'Meio-campo', 23), ('Jesper Karlström', 'Meio-campo', 23), ('Yasin Ayari', 'Meio-campo', 23),
('Mattias Svanberg', 'Meio-campo', 23), ('Daniel Svensson', 'Meio-campo', 23), ('Ken Sema', 'Meio-campo', 23), ('Roony Bardghji', 'Atacante', 23), ('Dejan Kulusevski', 'Atacante', 23),
('Anthony Elanga', 'Atacante', 23), ('Alexander Isak', 'Atacante', 23), ('Viktor Gyökeres', 'Atacante', 23),

-- Tunísia (id_selecao: 24)
('Bechir Ben Said', 'Goleiro', 24), ('Aymen Dahmen', 'Goleiro', 24), ('Van Valery', 'Defensor', 24), ('Montassar Talbi', 'Defensor', 24), ('Yassine Meriah', 'Defensor', 24),
('Ali Abdi', 'Defensor', 24), ('Dylan Bronn', 'Defensor', 24), ('Ellyes Skhiri', 'Meio-campo', 24), ('Aissa Laidouni', 'Meio-campo', 24), ('Ferjani Sassi', 'Meio-campo', 24),
('Mohamed Ali Ben Romdhane', 'Meio-campo', 24), ('Hannibal Mejbri', 'Meio-campo', 24), ('Elias Achouri', 'Atacante', 24), ('Elias Saad', 'Atacante', 24), ('Hazem Mastouri', 'Atacante', 24),
('Ismael Gharbi', 'Atacante', 24), ('Sayfallah Ltaief', 'Atacante', 24), ('Naim Sliti', 'Atacante', 24),

-- Bélgica (id_selecao: 25)
('Thibaut Courtois', 'Goleiro', 25), ('Arthur Theate', 'Defensor', 25), ('Timothy Castagne', 'Defensor', 25), ('Zeno Debast', 'Defensor', 25), ('Brandon Mechele', 'Defensor', 25),
('Maxim De Cuyper', 'Defensor', 25), ('Thomas Meunier', 'Defensor', 25), ('Youri Tielemans', 'Meio-campo', 25), ('Amadou Onana', 'Meio-campo', 25), ('Nicolas Raskin', 'Meio-campo', 25),
('Alexis Saelemaekers', 'Meio-campo', 25), ('Hans Vanaken', 'Meio-campo', 25), ('Kevin De Bruyne', 'Meio-campo', 25), ('Jérémy Doku', 'Atacante', 25), ('Charles De Ketelaere', 'Atacante', 25),
('Leandro Trossard', 'Atacante', 25), ('Loïs Openda', 'Atacante', 25), ('Romelu Lukaku', 'Atacante', 25),

-- Egito (id_selecao: 26)
('Mohamed El Shenawy', 'Goleiro', 26), ('Mohamed Hany', 'Defensor', 26), ('Mohamed Hamdy', 'Defensor', 26), ('Yasser Ibrahim', 'Defensor', 26), ('Khaled Sobhi', 'Defensor', 26),
('Ramy Rabia', 'Defensor', 26), ('Hossam Abdelmaguid', 'Defensor', 26), ('Ahmed Fatouh', 'Defensor', 26), ('Marwan Attia', 'Meio-campo', 26), ('Zizo', 'Meio-campo', 26),
('Hamdy Fathy', 'Meio-campo', 26), ('Mohamed Lasheen', 'Meio-campo', 26), ('Emam Ashour', 'Meio-campo', 26), ('Osama Faisal', 'Atacante', 26), ('Mohamed Salah', 'Atacante', 26),
('Mostafa Mohamed', 'Atacante', 26), ('Trezeguet', 'Atacante', 26), ('Omar Marmoush', 'Atacante', 26),

-- Irã (id_selecao: 27)
('Alireza Beiranvand', 'Goleiro', 27), ('Morteza Pouraliganji', 'Defensor', 27), ('Ehsan Hajsafi', 'Defensor', 27), ('Milad Mohammadi', 'Defensor', 27), ('Shoja Khalilzadeh', 'Defensor', 27),
('Ramin Rezaeian', 'Defensor', 27), ('Hossein Kanaani', 'Defensor', 27), ('Sadegh Moharrami', 'Defensor', 27), ('Saleh Hardani', 'Defensor', 27), ('Saeed Ezatolahi', 'Meio-campo', 27),
('Saman Ghoddos', 'Meio-campo', 27), ('Omid Noorafkan', 'Meio-campo', 27), ('Roozbeh Cheshmi', 'Meio-campo', 27), ('Mohammad Mohebi', 'Atacante', 27), ('Sardar Azmoun', 'Atacante', 27),
('Mehdi Taremi', 'Atacante', 27), ('Alireza Jahanbakhsh', 'Atacante', 27), ('Ali Gholizadeh', 'Atacante', 27),

-- Nova Zelândia (id_selecao: 28)
('Max Crocombe-Payne', 'Goleiro', 28), ('Alex Paulsen', 'Goleiro', 28), ('Michael Boxall', 'Defensor', 28), ('Liberato Cacace', 'Defensor', 28), ('Tim Payne', 'Defensor', 28),
('Tyler Bindon', 'Defensor', 28), ('Francis de Vries', 'Defensor', 28), ('Finn Surman', 'Defensor', 28), ('Joe Bell', 'Meio-campo', 28), ('Sarpreet Singh', 'Meio-campo', 28),
('Ryan Thomas', 'Meio-campo', 28), ('Matthew Garbett', 'Meio-campo', 28), ('Marko Stamenić', 'Meio-campo', 28), ('Ben Old', 'Meio-campo', 28), ('Chris Wood', 'Atacante', 28),
('Elijah Just', 'Atacante', 28), ('Callum McCowatt', 'Atacante', 28), ('Kosta Barbarouses', 'Atacante', 28),

-- Espanha (id_selecao: 29)
('Unai Simón', 'Goleiro', 29), ('Robin Le Normand', 'Defensor', 29), ('Aymeric Laporte', 'Defensor', 29), ('Dean Huijsen', 'Defensor', 29), ('Pedro Porro', 'Defensor', 29),
('Dani Carvajal', 'Defensor', 29), ('Marc Cucurella', 'Defensor', 29), ('Martín Zubimendi', 'Meio-campo', 29), ('Rodri', 'Meio-campo', 29), ('Pedri', 'Meio-campo', 29),
('Fabián Ruiz', 'Meio-campo', 29), ('Mikel Merino', 'Meio-campo', 29), ('Lamine Yamal', 'Atacante', 29), ('Dani Olmo', 'Atacante', 29), ('Nico Williams', 'Atacante', 29),
('Ferran Torres', 'Atacante', 29), ('Álvaro Morata', 'Atacante', 29), ('Mikel Oyarzabal', 'Atacante', 29),

-- Cabo Verde (id_selecao: 30)
('Vozinha', 'Goleiro', 30), ('Logan Costa', 'Defensor', 30), ('Pico', 'Defensor', 30), ('Diney', 'Defensor', 30), ('Steven Moreira', 'Defensor', 30),
('Wagner Pina', 'Defensor', 30), ('João Paulo', 'Meio-campo', 30), ('Yannick Semedo', 'Meio-campo', 30), ('Kevin Pina', 'Meio-campo', 30), ('Patrick Andrade', 'Meio-campo', 30),
('Jamiro Monteiro', 'Meio-campo', 30), ('Deroy Duarte', 'Meio-campo', 30), ('Garry Rodrigues', 'Atacante', 30), ('Jovane Cabral', 'Atacante', 30), ('Ryan Mendes', 'Atacante', 30),
('Dailon Livramento', 'Atacante', 30), ('Willy Semedo', 'Atacante', 30), ('Bebé', 'Atacante', 30),

-- Arábia Saudita (id_selecao: 31)
('Nawaf Alaqidi', 'Goleiro', 31), ('Abdulrahman Al-Sanbi', 'Goleiro', 31), ('Saud Abdulhamid', 'Defensor', 31), ('Nawaf Boushal', 'Defensor', 31), ('Jihad Thakri', 'Defensor', 31),
('Moteb Al-Harbi', 'Defensor', 31), ('Hassan Altambakti', 'Defensor', 31), ('Musab Aljuwayr', 'Meio-campo', 31), ('Ziyad Aljohani', 'Meio-campo', 31), ('Abdullah Alkhaibari', 'Meio-campo', 31),
('Nasser Aldawsari', 'Meio-campo', 31), ('Saleh Abu Alshamat', 'Meio-campo', 31), ('Marwan Alsahafi', 'Atacante', 31), ('Salem Aldawsari', 'Atacante', 31), ('Abdulrahman Al-Aboud', 'Atacante', 31),
('Feras Albrikan', 'Atacante', 31), ('Saleh Alshehri', 'Atacante', 31), ('Abdullah Al-Hamdan', 'Atacante', 31),

-- Uruguay (id_selecao: 32)
('Sergio Rochet', 'Goleiro', 32), ('Santiago Mele', 'Goleiro', 32), ('Ronald Araujo', 'Defensor', 32), ('José María Giménez', 'Defensor', 32), ('Sebastian Caceres', 'Defensor', 32),
('Mathias Olivera', 'Defensor', 32), ('Guillermo Varela', 'Defensor', 32), ('Nahitan Nandez', 'Meio-campo', 32), ('Federico Valverde', 'Meio-campo', 32), ('Giorgian De Arrascaeta', 'Meio-campo', 32),
('Rodrigo Bentancur', 'Meio-campo', 32), ('Manuel Ugarte', 'Meio-campo', 32), ('Nicolás de la Cruz', 'Meio-campo', 32), ('Maxi Araujo', 'Atacante', 32), ('Darwin Núñez', 'Atacante', 32),
('Federico Viñas', 'Atacante', 32), ('Rodrigo Aguirre', 'Atacante', 32), ('Facundo Pellistri', 'Atacante', 32),

-- França (id_selecao: 33)
('Mike Maignan', 'Goleiro', 33), ('Theo Hernández', 'Defensor', 33), ('William Saliba', 'Defensor', 33), ('Jules Koundé', 'Defensor', 33), ('Ibrahima Konaté', 'Defensor', 33),
('Dayot Upamecano', 'Defensor', 33), ('Lucas Digne', 'Defensor', 33), ('Aurélien Tchouaméni', 'Meio-campo', 33), ('Eduardo Camavinga', 'Meio-campo', 33), ('Manu Koné', 'Meio-campo', 33),
('Adrien Rabiot', 'Meio-campo', 33), ('Michael Olise', 'Meio-campo', 33), ('Ousmane Dembélé', 'Atacante', 33), ('Bradley Barcola', 'Atacante', 33), ('Désiré Doué', 'Atacante', 33),
('Kingsley Coman', 'Atacante', 33), ('Hugo Ekitike', 'Atacante', 33), ('Kylian Mbappé', 'Atacante', 33),

-- Senegal (id_selecao: 34)
('Eduardo Mendy', 'Goleiro', 34), ('Yehvann Diouf', 'Goleiro', 34), ('Moussa Niakhaté', 'Defensor', 34), ('Abdoulaye Seck', 'Defensor', 34), ('Ismail Jakobs', 'Defensor', 34),
('El Hadji Malick Diouf', 'Defensor', 34), ('Kalidou Koulibaly', 'Defensor', 34), ('Idrissa Gana Gueye', 'Meio-campo', 34), ('Pape Matar Sarr', 'Meio-campo', 34), ('Pape Gueye', 'Meio-campo', 34),
('Habib Diarra', 'Meio-campo', 34), ('Lamine Camara', 'Meio-campo', 34), ('Sadio Mane', 'Atacante', 34), ('Ismaïla Sarr', 'Atacante', 34), ('Boulaye Dia', 'Atacante', 34),
('Iliman Ndiaye', 'Atacante', 34), ('Nicolas Jackson', 'Atacante', 34), ('Krepin Diatta', 'Atacante', 34),

-- Iraque (id_selecao: 35)
('Jalal Hassan', 'Goleiro', 35), ('Rebin Sulaka', 'Defensor', 35), ('Hussein Ali', 'Defensor', 35), ('Akam Hashem', 'Defensor', 35), ('Merchas Doski', 'Defensor', 35),
('Zaid Tahseen', 'Defensor', 35), ('Manaf Younis', 'Defensor', 35), ('Zidane Iqbal', 'Meio-campo', 35), ('Amir Al-Ammari', 'Meio-campo', 35), ('Ibrahim Bayesh', 'Meio-campo', 35),
('Ali Jasim', 'Meio-campo', 35), ('Youssef Amyn', 'Meio-campo', 35), ('Aimar Sher', 'Meio-campo', 35), ('Marko Farji', 'Meio-campo', 35), ('Osama Rashid', 'Meio-campo', 35),
('Ali Al-Hamadi', 'Atacante', 35), ('Aymen Hussein', 'Atacante', 35), ('Mohanad Ali', 'Atacante', 35),

-- Noruega (id_selecao: 36)
('Ørjan Nyland', 'Goleiro', 36), ('Julian Ryerson', 'Defensor', 36), ('Leo Østigård', 'Defensor', 36), ('Kristoffer Ajer', 'Defensor', 36), ('Marcus Holmgren Pedersen', 'Defensor', 36),
('David Møller Wolfe', 'Defensor', 36), ('Torbjørn Heggem', 'Defensor', 36), ('Morten Thorsby', 'Meio-campo', 36), ('Martin Ødegaard', 'Meio-campo', 36), ('Sander Berge', 'Meio-campo', 36),
('Andreas Schjelderup', 'Meio-campo', 36), ('Patrick Berg', 'Meio-campo', 36), ('Erling Haaland', 'Atacante', 36), ('Alexander Sørloth', 'Atacante', 36), ('Aron Dønnum', 'Atacante', 36),
('Jørgen Strand Larsen', 'Atacante', 36), ('Antonio Nusa', 'Atacante', 36), ('Oscar Bobb', 'Atacante', 36),

-- Argentina (id_selecao: 37)
('Emiliano Martínez', 'Goleiro', 37), ('Nahuel Molina', 'Defensor', 37), ('Cristian Romero', 'Defensor', 37), ('Nicolás Otamendi', 'Defensor', 37), ('Nicolás Tagliafico', 'Defensor', 37),
('Leonardo Balerdi', 'Defensor', 37), ('Enzo Fernández', 'Meio-campo', 37), ('Alexis Mac Allister', 'Meio-campo', 37), ('Rodrigo De Paul', 'Meio-campo', 37), ('Exequiel Palacios', 'Meio-campo', 37),
('Leandro Paredes', 'Meio-campo', 37), ('Nico Paz', 'Meio-campo', 37), ('Franco Mastantuono', 'Meio-campo', 37), ('Nico González', 'Atacante', 37), ('Lionel Messi', 'Atacante', 37),
('Lautaro Martínez', 'Atacante', 37), ('Julián Álvarez', 'Atacante', 37), ('Giuliano Simeone', 'Atacante', 37),

-- Argélia (id_selecao: 38)
('Alexis Guendouz', 'Goleiro', 38), ('Ramy Bensebaini', 'Defensor', 38), ('Youcef Atal', 'Defensor', 38), ('Rayan Aït-Nouri', 'Defensor', 38), ('Mohamed Amine Tougai', 'Defensor', 38),
('Aïssa Mandi', 'Defensor', 38), ('Ismael Bennacer', 'Meio-campo', 38), ('Houssem Aouar', 'Meio-campo', 38), ('Hicham Boudaoui', 'Meio-campo', 38), ('Ramiz Zerrouki', 'Meio-campo', 38),
('Nabil Bentaleb', 'Meio-campo', 38), ('Farés Chaibi', 'Meio-campo', 38), ('Riyad Mahrez', 'Atacante', 38), ('Said Benrahma', 'Atacante', 38), ('Anis Hadj Moussa', 'Atacante', 38),
('Amine Gouiri', 'Atacante', 38), ('Baghdad Bounedjah', 'Atacante', 38), ('Mohammed Amoura', 'Atacante', 38),

-- Áustria (id_selecao: 39)
('Alexander Schlager', 'Goleiro', 39), ('Patrick Pentz', 'Goleiro', 39), ('David Alaba', 'Defensor', 39), ('Kevin Danso', 'Defensor', 39), ('Philipp Lienhart', 'Defensor', 39),
('Stefan Posch', 'Defensor', 39), ('Phillipp Mwene', 'Defensor', 39), ('Alexander Prass', 'Meio-campo', 39), ('Xaver Schlager', 'Meio-campo', 39), ('Marcel Sabitzer', 'Meio-campo', 39),
('Konrad Laimer', 'Meio-campo', 39), ('Florian Grillitsch', 'Meio-campo', 39), ('Nicolas Seiwald', 'Meio-campo', 39), ('Romano Schmid', 'Meio-campo', 39), ('Patrick Wimmer', 'Atacante', 39),
('Christoph Baumgartner', 'Atacante', 39), ('Michael Gregoritsch', 'Atacante', 39), ('Marko Arnautović', 'Atacante', 39),

-- Jordânia (id_selecao: 40)
('Yazeed Abulaila', 'Goleiro', 40), ('Ihsan Haddad', 'Defensor', 40), ('Mohammad Abu Hashish', 'Defensor', 40), ('Yazan Al-Arab', 'Defensor', 40), ('Abdallah Nasib', 'Defensor', 40),
('Saleem Obaid', 'Defensor', 40), ('Mohammad Abualnadi', 'Defensor', 40), ('Ibrahim Saadeh', 'Meio-campo', 40), ('Nizar Al-Rashdan', 'Meio-campo', 40), ('Noor Al-Rawabdeh', 'Meio-campo', 40),
('Mohannad Abu Taha', 'Meio-campo', 40), ('Amer Jamous', 'Meio-campo', 40), ('Musa Al-Taamari', 'Atacante', 40), ('Yazan Al-Naimat', 'Atacante', 40), ('Mahmoud Al-Mardi', 'Atacante', 40),
('Ali Olwan', 'Atacante', 40), ('Mohammad Abu Zrayq', 'Atacante', 40), ('Ibrahim Sabra', 'Atacante', 40),

-- Portugal (id_selecao: 41)
('Diogo Costa', 'Goleiro', 41), ('Jose Sa', 'Goleiro', 41), ('Ruben Dias', 'Defensor', 41), ('João Cancelo', 'Defensor', 41), ('Diogo Dalot', 'Defensor', 41),
('Nuno Mendes', 'Defensor', 41), ('Gonçalo Inácio', 'Defensor', 41), ('Bernardo Silva', 'Meio-campo', 41), ('Bruno Fernandes', 'Meio-campo', 41), ('Ruben Neves', 'Meio-campo', 41),
('Vitinha', 'Meio-campo', 41), ('João Neves', 'Meio-campo', 41), ('Cristiano Ronaldo', 'Atacante', 41), ('Francisco Trincão', 'Atacante', 41), ('João Felix', 'Atacante', 41),
('Gonçalo Ramos', 'Atacante', 41), ('Pedro Neto', 'Atacante', 41), ('Rafael Leão', 'Atacante', 41),

-- RD Congo (id_selecao: 42)
('Lionel Mpasi', 'Goleiro', 42), ('Aaron Wan-Bissaka', 'Defensor', 42), ('Axel Tuanzebe', 'Defensor', 42), ('Arthur Masuaku', 'Defensor', 42), ('Chancel Mbemba', 'Defensor', 42),
('Joris Kayembe', 'Defensor', 42), ('Charles Pickel', 'Meio-campo', 42), ('Ngal’ayel Mukau', 'Meio-campo', 42), ('Edo Kayembe', 'Meio-campo', 42), ('Samuel Moutoussamy', 'Meio-campo', 42),
('Noah Sadiki', 'Meio-campo', 42), ('Théo Bongonda', 'Atacante', 42), ('Meschack Elia', 'Atacante', 42), ('Yoane Wissa', 'Atacante', 42), ('Brian Cipenga', 'Atacante', 42),
('Fiston Mayele', 'Atacante', 42), ('Cédric Bakambu', 'Atacante', 42), ('Nathanaël Mbuku', 'Atacante', 42),

-- Uzbequistão (id_selecao: 43)
('Utkir Yusupov', 'Goleiro', 43), ('Farrukh Savfiev', 'Defensor', 43), ('Sherzod Nasrullaev', 'Defensor', 43), ('Umar Eshmurodov', 'Defensor', 43), ('Husniddin Aliqulov', 'Defensor', 43),
('Rustamjon Ashurmatov', 'Defensor', 43), ('Khojiakbar Alijonov', 'Defensor', 43), ('Abdukodir Khusanov', 'Defensor', 43), ('Odiljon Hamrobekov', 'Meio-campo', 43), ('Otabek Shukurov', 'Meio-campo', 43),
('Jamshid Iskanderov', 'Meio-campo', 43), ('Azizbek Turgunboev', 'Meio-campo', 43), ('Khojimat Erkinov', 'Atacante', 43), ('Eldor Shomurodov', 'Atacante', 43), ('Oston Urunov', 'Atacante', 43),
('Jaloliddin Masharipov', 'Atacante', 43), ('Igor Sergeev', 'Atacante', 43), ('Abbosbek Fayzullaev', 'Atacante', 43),

-- Colômbia (id_selecao: 44)
('Camilo Vargas', 'Goleiro', 44), ('David Ospina', 'Goleiro', 44), ('Dávinson Sánchez', 'Defensor', 44), ('Yerry Mina', 'Defensor', 44), ('Daniel Muñoz', 'Defensor', 44),
('Johan Mojica', 'Defensor', 44), ('Jhon Lucumí', 'Defensor', 44), ('Santiago Arias', 'Defensor', 44), ('Jefferson Lerma', 'Meio-campo', 44), ('Kevin Castaño', 'Meio-campo', 44),
('Richard Ríos', 'Meio-campo', 44), ('James Rodríguez', 'Meio-campo', 44), ('Juan Fernando Quintero', 'Meio-campo', 44), ('Jorge Carrascal', 'Meio-campo', 44), ('Jhon Arias', 'Atacante', 44),
('Jhon Córdoba', 'Atacante', 44), ('Luis Suárez', 'Atacante', 44), ('Luis Díaz', 'Atacante', 44),

-- Inglaterra (id_selecao: 45)
('Jordan Pickford', 'Goleiro', 45), ('John Stones', 'Defensor', 45), ('Marc Guéhi', 'Defensor', 45), ('Ezri Konsa', 'Defensor', 45), ('Trent Alexander-Arnold', 'Defensor', 45),
('Reece James', 'Defensor', 45), ('Dan Burn', 'Defensor', 45), ('Jordan Henderson', 'Meio-campo', 45), ('Declan Rice', 'Meio-campo', 45), ('Jude Bellingham', 'Meio-campo', 45),
('Cole Palmer', 'Meio-campo', 45), ('Morgan Rogers', 'Meio-campo', 45), ('Anthony Gordon', 'Atacante', 45), ('Phil Foden', 'Atacante', 45), ('Bukayo Saka', 'Atacante', 45),
('Harry Kane', 'Atacante', 45), ('Marcus Rashford', 'Atacante', 45), ('Ollie Watkins', 'Atacante', 45),

-- Croácia (id_selecao: 46)
('Dominik Livaković', 'Goleiro', 46), ('Duje Ćaleta-Car', 'Defensor', 46), ('Joško Gvardiol', 'Defensor', 46), ('Josip Stanišić', 'Defensor', 46), ('Luka Vušković', 'Defensor', 46),
('Josip Šutalo', 'Defensor', 46), ('Kristijan Jakić', 'Meio-campo', 46), ('Luka Modrić', 'Meio-campo', 46), ('Mateo Kovačić', 'Meio-campo', 46), ('Martin Baturina', 'Meio-campo', 46),
('Lovro Majer', 'Meio-campo', 46), ('Mario Pašalić', 'Meio-campo', 46), ('Petar Sučić', 'Meio-campo', 46), ('Ivan Perišić', 'Atacante', 46), ('Marco Pašalić', 'Atacante', 46),
('Ante Budimir', 'Atacante', 46), ('Andrej Kramarić', 'Atacante', 46), ('Franjo Ivanović', 'Atacante', 46),

-- Gana (id_selecao: 47)
('Lawrence Ati Zigi', 'Goleiro', 47), ('Tariq Lamptey', 'Defensor', 47), ('Mohammed Salisu', 'Defensor', 47), ('Alidu Seidu', 'Defensor', 47), ('Alexander Djiku', 'Defensor', 47),
('Gideon Mensah', 'Defensor', 47), ('Caleb Yirenkyi', 'Meio-campo', 47), ('Abdul Fatawu Issahaku', 'Meio-campo', 47), ('Thomas Partey', 'Meio-campo', 47), ('Salis Abdul Samed', 'Meio-campo', 47),
('Kamaldeen Sulemana', 'Meio-campo', 47), ('Mohammed Kudus', 'Meio-campo', 47), ('Iñaki Williams', 'Atacante', 47), ('Jordan Ayew', 'Atacante', 47), ('André Ayew', 'Atacante', 47),
('Joseph Paintsil', 'Atacante', 47), ('Osman Bukari', 'Atacante', 47), ('Antoine Semenyo', 'Atacante', 47),

-- Panamá (id_selecao: 48)
('Orlando Mosquera', 'Goleiro', 48), ('Luis Mejía', 'Goleiro', 48), ('Fidel Escobar', 'Defensor', 48), ('Andrés Andrade', 'Defensor', 48), ('Michael Amir Murillo', 'Defensor', 48),
('Eric Davis', 'Defensor', 48), ('José Córdoba', 'Defensor', 48), ('César Blackman', 'Defensor', 48), ('Cristian Martínez', 'Meio-campo', 48), ('Aníbal Godoy', 'Meio-campo', 48),
('Adalberto Carrasquilla', 'Meio-campo', 48), ('Édgar Bárcenas', 'Meio-campo', 48), ('Carlos Harvey', 'Meio-campo', 48), ('Ismael Díaz', 'Atacante', 48), ('José Fajardo', 'Atacante', 48),
('Cecilio Waterman', 'Atacante', 48), ('José Luis Rodríguez', 'Atacante', 48), ('Alberto Quintero', 'Atacante', 48);
COMMIT;
