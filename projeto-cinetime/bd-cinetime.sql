CREATE DATABASE cinetime;

USE cinetime;

CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    nome_usuario VARCHAR(50) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE plataforma (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    tipo_plataforma ENUM('Streaming', 'TV aberta', 'TV a cabo', 'Cinema', 'Locadora Digital'),
    url_plataforma VARCHAR(750) UNIQUE
);

CREATE TABLE obras (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tipo_obra ENUM('Filme', 'Série', 'TV Show', 'Minissérie') NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    ano_lancamento YEAR NOT NULL,
    genero VARCHAR(50) NOT NULL,
    sinopse TEXT NOT NULL,
    nota_critica DECIMAL(2,1) CHECK (nota_critica IN (1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5)),
    id_plataforma INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_plataforma) REFERENCES plataforma(id)
);

CREATE TABLE avaliacoes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nota DECIMAL(2,1) NOT NULL 
      CHECK (nota BETWEEN 1 AND 5 AND nota * 2 = FLOOR(nota * 2)),
    texto TEXT CHECK(CHAR_LENGTH(texto) BETWEEN 1 AND 4000),
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    curtidas INT UNSIGNED DEFAULT 0,
    id_usuario INT UNSIGNED NOT NULL,
    id_obra INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES users(id),
    FOREIGN KEY (id_obra) REFERENCES obras(id)
);

CREATE TABLE comentarios (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    texto TEXT NOT NULL,
    data_criacao DATETIME NOT NULL,
    id_usuario INT UNSIGNED NOT NULL,
    id_avaliacao INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES users(id),
    FOREIGN KEY (id_avaliacao) REFERENCES avaliacoes(id)
);
