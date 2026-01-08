http://groups.di.unipi.it/~leoni/BDeSI/E2.Esercizi%20di%20SQL.pdf
https://learnsql.it/blog/10-esercizi-sulle-subquery-correlate-con-soluzioni/
https://dbdmg.polito.it/wordpress/wp-content/uploads/2010/12/Unita3_Lezione3_EserciziRiepilogo.pdf
https://dbdmg.polito.it/dbdmg_web/wp-content/uploads/2023/05/EserciziSQL-parte1_sol.pdf

http://spdp.di.unimi.it/papers/EserciziarioBD.pdf 

2.2.2 Le Feste
Sia dato lo schema relazionale:
FESTA(Codice, Costo, NomeRistorante)
REGALO(nome_invitato, CodiceFesta, Regalo)
INVITATO(Nome, Indirizzo, Telefono)

Interrogazione 1
Determinare, per ogni festa, il nome dell’invitato più generoso, ovvero
dell’invitato che ha portato il maggior numero di regali.

SELECT nome_invitato,
       CodiceFesta, 
       COUNT(Regalo) AS numero_regali
FROM REGALO AS REG_2
GROUP BY nome_invitato
HAVING numero_regali >= ALL (
  SELECT COUNT(*)
  FROM REGALO AS REG_2
  WHERE REG_2.CodiceFesta = REG_1.CodiceFesta
  GROUP BY REG_2.nome_invitato
)

Interrogazione 2
Determinare il nome degli invitati che hanno partecipato alla festa pi`u costosa.

SELECT nome_invitato
FROM REGALO
WHERE CodiceFesta IN (
    SELECT Codice
    FROM FESTA
    WHERE Costo >= ALL (
          SELECT Costo
          FROM FESTA
  )
)


Interrogazione 3
Determinare il codice delle feste dove almeno un invitato ha portato tre regali.

SELECT CodiceFesta,
       nome_invitato,
       COUNT (regalo) AS numero_regali
FROM REGALO
GROUP BY nome_invitato 
HAVING numero_regali >= 3

2.2.3 Autobus
Sia dato lo schema relazionale:
AUTISTA(CF, Nome, Cognome, Età, NumAutobus)
PERCORRE(NumAutobus, NomeStrada)
STRADA(NomeStrada, Lunghezza, Pedonale)
Si noti che: Pedonale `e un attributo booleano che vale true se la strada `e di tipo pedonale;
false altrimenti.

Interrogazione 2
Determinare gli autobus (NumAutobus) che percorrono tutte le strade pedonali,
ed eventualmente anche altre strade.



Interrogazione 3
Conteggiare gli autobus che percorrono solo strade pedonali (non devono
necessariamente percorrerle tutte).

SELECT NumAutobus
FROM PERCORRE
WHERE NOT EXISTS (
  SELECT *
  FROM STRADA
  WHERE Pedonale = FALSE
) 


  
2.3.4 Donut
Sia dato lo schema relazionale:
DONUT(Codice, Nome, Crema, Glassa, Decorazione, DataPrimaProduzione)
CLIENTE(CF, Nome, Cognome, Citt`aResidenza, DataNascita)
ACQUISTO(CFCliente, CodiceDonut, DataAcquisto)

1. Determinare il codice dei donut con glassa al ‘cioccolato’ che sono stati prodotti per
la prima volta nel 1999 e che sono stati acquistati da pi`u di 2000 diversi clienti.

SELECT Codice
FROM DONUT
WHERE Glassa = "cioccolato" AND 
      DataPrimaProduzione = "1999" AND 
      Codice IN (
        SELECT CodiceDonut
        FROM ACQUISTO
        WHERE COUNT(CFCliente) > 2000
      )
  
/*OPPPURE*/

SELECT Codice
FROM DONUT
JOIN ACQUISTO ON ACQUISTO.CodiceDonut = DONUT.Codice
WHERE Glassa = "cioccolato" AND 
      DataPrimaProduzione = "1999" AND 
GROUP BY Codice
HAVING COUNT(CFCliente) > 2000
  
2. Determinare il nome e cognome dei clienti che hanno acquistato donut farciti di crema
‘pasticciera’ e decorati con ‘zucchero a granelli’ ma che non hanno mai acquistato
donut con glassa al ‘cioccolato’.
3. Determinare il nome, cognome e il codice fiscale dei clienti che hanno acquistato almeno
tre differenti tipi di Donut.

2.3.7 Rimborso
Sia dato lo schema relazionale:
FONDO(Codice, Importo, DataInizioErogazione, Scadenza, MatrAmministratore)
DIPENDENTE(Matricola, Nome, Cognome, Posizione)
PARTECIPA(MatrDipendente, CodiceFondo)

1. Determinare il nome e cognome dei dipendenti che non sono amministratori di fondi
erogati a partire dal 2003.
2. Determinare i fondi (si richiede di restituire il codice del fondo e la scadenza) per i
quali tutti i partecipanti sono anche amministratori di fondi.
3. Determinare il nome e il cognome degli amministratori del fondo pi`u vecchio (cio`e,
quello con data di inizio erogazione pi`u vecchia).

2.3.8 Sentenze
Sia dato lo schema relazionale:
PERSONA(CF, Nome, Cognome, DataNascita, Citt`aNascita, Citt`aResidenza)
CONDANNA(CFPersona, DataCondanna, Tipo, Citt`aReato, AnnoReato, Durata)

1. Determinare il numero medio annuo di condanne per ‘omicidio’ che si sono verificati
nella citt`a di Milano.
2. Determinare il codice fiscale, nome e cognome di tutte le persone nate nel 1971 che
non hanno mai subito una condanna per un reato compiuto nella citt`a di nascita (o
che non sono mai state condannate).
3. Determinare le citt`a ove si compiono pi`u reati.
