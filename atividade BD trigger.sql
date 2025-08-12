CREATE DATABASE Biblioteca;
USE Biblioteca;

CREATE TABLE Alunos (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    data_nascimento DATE
);
CREATE TABLE Livros (
    id_livro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    editora VARCHAR(100),
    ano_publicacao INT,
    quantidade INT NOT NULL DEFAULT 0,
    status VARCHAR(20) DEFAULT 'disponível'
);
CREATE TABLE Autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50)
);
CREATE TABLE Livro_Autor (
    id_livro INT,
    id_autor INT,
    PRIMARY KEY (id_livro, id_autor),
    FOREIGN KEY (id_livro) REFERENCES Livros(id_livro),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor)
);
CREATE TABLE Emprestimos (
    id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_livro INT NOT NULL,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    FOREIGN KEY (id_aluno) REFERENCES Alunos(id_aluno),
    FOREIGN KEY (id_livro) REFERENCES Livros(id_livro),
    CHECK (data_devolucao IS NULL OR data_devolucao >= data_emprestimo)
);
DELIMITER $$

CREATE TRIGGER trg_diminuir_quantidade
BEFORE INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    DECLARE qtd INT;

    SELECT quantidade INTO qtd
    FROM Livros
    WHERE id_livro = NEW.id_livro;

    IF qtd <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Não há livros disponíveis para empréstimo.';
    ELSE
        UPDATE Livros
        SET quantidade = quantidade - 1
        WHERE id_livro = NEW.id_livro;

        IF qtd = 1 THEN
            UPDATE Livros
            SET status = 'indisponível'
            WHERE id_livro = NEW.id_livro;
        END IF;
    END IF;
END$$

DELIMITER ;


