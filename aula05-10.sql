create database Populacao;
use Populacao;

-- Criação da tabela Estado
CREATE TABLE Estado (
    Sigla VARCHAR(2) PRIMARY KEY,
    NomeEstado VARCHAR(255) NOT NULL
);

-- Criação da tabela Cidade
CREATE TABLE Cidade (
    IdCidade INT PRIMARY KEY AUTO_INCREMENT,
    NomeCidade VARCHAR(255) NOT NULL,
    IdEstado VARCHAR(2),
    FOREIGN KEY (IdEstado) REFERENCES Estado(Sigla)
);

-- Criação da tabela Pessoa
CREATE TABLE Pessoa (
    IdPessoa INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(255) NOT NULL,
    Rua VARCHAR(255),
    Numero VARCHAR(10),
    CEP VARCHAR(10),
    Sexo CHAR(1),
    Apelido VARCHAR(255)
);

-- Criação da tabela PessoaJuridica (especialização de Pessoa)
CREATE TABLE PessoaJuridica (
    IdPessoa INT PRIMARY KEY,
    CNPJ VARCHAR(18) UNIQUE NOT NULL,
    InscricaoEstadual VARCHAR(20),
    NomeFantasia VARCHAR(255),
    RazaoSocial VARCHAR(255),
    FOREIGN KEY (IdPessoa) REFERENCES Pessoa(IdPessoa)
);

-- Criação da tabela PessoaFisica (especialização de Pessoa)
CREATE TABLE PessoaFisica (
    IdPessoa INT PRIMARY KEY,
    CPF VARCHAR(14) UNIQUE NOT NULL,
    RG VARCHAR(20),
    EstadoEmissor VARCHAR(2),
    NomeEstadoEmissor VARCHAR(255),
    FOREIGN KEY (IdPessoa) REFERENCES Pessoa(IdPessoa),
    FOREIGN KEY (EstadoEmissor) REFERENCES Estado(Sigla)
);



ALTER TABLE Pessoa
ADD COLUMN IdCidade INT,
ADD FOREIGN KEY (IdCidade) REFERENCES Cidade(IdCidade);

-- Criação da tabela de relacionamento entre PessoaFisica e PessoaJuridica
CREATE TABLE Propriedade (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    IDPessoaFisica INT,
    IDPessoaJuridica INT,
    FOREIGN KEY (IDPessoaFisica) REFERENCES PessoaFisica(IDPessoa),
    FOREIGN KEY (IDPessoaJuridica) REFERENCES PessoaJuridica(IDPessoa)
);


-- Criação da tabela UnidadeMilitar
CREATE TABLE UnidadeMilitar (
    IdUnidadeMilitar INT PRIMARY KEY AUTO_INCREMENT,
    NomeUM VARCHAR(255) NOT NULL,
    EnderecoCompleto VARCHAR(255) NOT NULL,
    IdCidade INT,
    FOREIGN KEY (IdCidade) REFERENCES Cidade(IdCidade)
);

-- Criação da tabela Horda
CREATE TABLE Horda (
    IdHorda INT PRIMARY KEY AUTO_INCREMENT,
    DataInicio DATE,
    IdUnidadeMilitar INT UNIQUE,
    FOREIGN KEY (IdUnidadeMilitar) REFERENCES UnidadeMilitar(IdUnidadeMilitar)
);


-- Criação da tabela TipoDoacao
CREATE TABLE TipoDoacao (
    IdTipoDoacao INT PRIMARY KEY AUTO_INCREMENT,
    NomeTipo VARCHAR(50) NOT NULL
);



-- Criação da tabela Doacao
CREATE TABLE Doacao (
    IdDoacao INT PRIMARY KEY AUTO_INCREMENT,
    Valor DECIMAL(10, 2) NOT NULL,
    DataDoacao DATE NOT NULL,
    IdTipoDoacao INT,
    IdPessoa INT,
    IdHorda INT,
    FOREIGN KEY (IdTipoDoacao) REFERENCES TipoDoacao(IdTipoDoacao),
    FOREIGN KEY (IdPessoa) REFERENCES Pessoa(IdPessoa),
    FOREIGN KEY (IdHorda) REFERENCES Horda(IdHorda)
);


-- Criação da tabela de relacionamento entre PessoaFisica e Horda
CREATE TABLE ParticipacaoHorda (
    IdParticipacao INT PRIMARY KEY AUTO_INCREMENT,
    IdPessoaFisica INT,
    IdHorda INT,
    DataInicio DATE NOT NULL,
    DataFim DATE,
    FOREIGN KEY (IdPessoaFisica) REFERENCES PessoaFisica(IdPessoa),
    FOREIGN KEY (IdHorda) REFERENCES Horda(IdHorda)
);



-- Criação de indeces

-- Tabela Cidade

CREATE INDEX idx_nome_cidade ON Cidade (NomeCidade);





-- Tabela Pessoa indice para rua e numero:

CREATE INDEX idx_rua_numero_cidade ON Cidade (Rua, Numero);




-- Criação de views

CREATE VIEW View_PessoaFisica AS
SELECT IdPessoa, CPF, RG, EstadoEmissor, NomeEstadoEmissor
FROM PessoaFisica;

CREATE VIEW View_PessoaJuridica AS
SELECT IdPessoa, CNPJ, InscricaoEstadual, NomeFantasia, RazaoSocial
FROM PessoaJuridica;
















CREATE VIEW View_UnidadeMilitarInfo AS
SELECT
    UM.IdUnidadeMilitar,
    UM.NomeUM,
    UM.EnderecoCompleto,
    CID.NomeCidade AS NomeCidadeUnidade,
    EST.NomeEstado AS NomeEstadoUnidade
FROM
    UnidadeMilitar UM,
    Cidade CID,
    Estado EST
WHERE
    UM.IdCidade = CID.IdCidade
    AND CID.IdEstado = EST.Sigla;






-- Criação com o SQL99

CREATE VIEW View_UnidadeMilitarInfo AS
SELECT
    UM.IdUnidadeMilitar,
    UM.NomeUM,
    UM.EnderecoCompleto,
    CID.NomeCidade AS NomeCidadeUnidade,
    EST.NomeEstado AS NomeEstadoUnidade
FROM
    UnidadeMilitar UM
INNER JOIN
    Cidade CID ON UM.IdCidade = CID.IdCidade
INNER JOIN
    Estado EST ON CID.IdEstado = EST.Sigla;