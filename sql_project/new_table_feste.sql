/*
http://spdp.di.unimi.it/papers/EserciziarioBD.pdf 

2.2.2 Le Feste
Sia dato lo schema relazionale:
FESTA(Codice, Costo, NomeRistorante)
REGALO(NomeInvitato, CodiceFesta, Regalo)
INVITATO(Nome, Indirizzo, Telefono)
*/

--Creazione Database es_sql
CREATE DATABASE es_sql;

CREATE TABLE public.festa (
  codice_id INT PRIMARY KEY,
  costo_festa DEC,
  nome_ristorante TEXT
);

CREATE TABLE public.invitato (
  nome_cognome_invitato TEXT PRIMARY KEY,
  indirizzo_invitato VARCHAR(100),
  num_telefono INT
);

CREATE TABLE public.regalo (
  nome_invitato TEXT,
  codice_festa_id INT,
  regalo_festa TEXT,
  PRIMARY KEY (nome_invitato, codice_festa_id),
  FOREIGN KEY (nome_invitato) REFERENCES public.invitato (nome_invitato),
  FOREIGN KEY (codice_festa_id) REFERENCES public.festa (codice_id)
);

-- Set ownership of the tables to the postgres user
ALTER TABLE public.company_dim OWNER to postgres;
ALTER TABLE public.skills_dim OWNER to postgres;
ALTER TABLE public.job_postings_fact OWNER to postgres;
ALTER TABLE public.skills_job_dim OWNER to postgres;

-- Create indexes on foreign key columns for better performance
CREATE INDEX idx_company_id ON public.job_postings_fact (company_id);
CREATE INDEX idx_skill_id ON public.skills_job_dim (skill_id);
CREATE INDEX idx_job_id ON public.skills_job_dim (job_id);
