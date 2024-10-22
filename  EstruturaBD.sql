-- Criando o tipo ENUM 'status_enum' para ser usado em 'Reserva'
CREATE TYPE status_enum AS ENUM (
    'ATIVO',
    'PENDENTE',
    'CANCELADO',
    'NO_SHOW',
    'CHECK_IN',
    'CHECK_OUT'
);

-- Criando o tipo ENUM 'tipo_quarto_enum' para ser usado em 'Quarto'
CREATE TYPE tipo_quarto_enum AS ENUM (
    'SUITE',
    'QUARTO_INDIVIDUAL',
    'QUARTO_FAMILIAR',
    'QUARTO_EXECUTIVO'
);

-- Criando a tabela 'Hotel'
CREATE TABLE Hotel (
    hotel_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200) NOT NULL
);

-- Criando a tabela 'Quarto'
CREATE TABLE Quarto (
    quarto_id SERIAL PRIMARY KEY,
    numero INT NOT NULL,
    tipo tipo_quarto_enum NOT NULL,
    lotacao INT NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    em_manutencao BOOLEAN NOT NULL,
    hotel_id INT,
    CONSTRAINT fk_hotel
        FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

-- Criando a tabela 'Cliente'
CREATE TABLE Cliente (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(200)
);

-- Criando a tabela 'Reserva'
CREATE TABLE Reserva (
    reserva_id SERIAL PRIMARY KEY,
    cliente_id INT,
    quarto_id INT,
    data_inicio DATE NOT NULL,
    data_final DATE NOT NULL,
    status status_enum NOT NULL,
    CONSTRAINT fk_cliente
        FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    CONSTRAINT fk_quarto
        FOREIGN KEY (quarto_id) REFERENCES Quarto(quarto_id)
);


-- Tabela de relacionamento entre 'Hotel' e 'Cliente' (Clientes do Hotel)
CREATE TABLE Hotel_Cliente (
    hotel_id INT,
    cliente_id INT,
    PRIMARY KEY (hotel_id, cliente_id),
    CONSTRAINT fk_hotel_cliente_hotel
        FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id),
    CONSTRAINT fk_hotel_cliente_cliente
        FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);

-- Criando a tabela para histórico de reservas do cliente
CREATE TABLE Historico_Reserva (
    historico_id SERIAL PRIMARY KEY,
    cliente_id INT,
    reserva_id INT,
    CONSTRAINT fk_historico_cliente
        FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    CONSTRAINT fk_historico_reserva
        FOREIGN KEY (reserva_id) REFERENCES Reserva(reserva_id)
);

-- Exemplo de algumas constraints adicionais
ALTER TABLE Quarto
ADD CONSTRAINT ck_quarto_preco CHECK (preco > 0);

ALTER TABLE Reserva
ADD CONSTRAINT ck_reserva_data CHECK (data_final > data_inicio);