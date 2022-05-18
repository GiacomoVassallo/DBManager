drop database if exists Campionato;

create database Campionato;

use Campionato;

create table Squadra(   Nome VARCHAR(20) PRIMARY KEY,
                        Sede VARCHAR(20) NOT NULL
                    );

create table Tesserato( CodiceTessera VARCHAR(7),
                        Nome VARCHAR(20) NOT NULL,
                        Cognome VARCHAR(20) NOT NULL,
                        DataNascita DATE NOT NULL,
                        Tipo VARCHAR(10) NOT NULL CHECK ( Tipo LIKE 'Giocatore' OR
                                                          Tipo LIKE 'Allenatore'),
                        Stipendio INT,
                        ScadenzaContratto DATE,
                        Squadra VARCHAR(20),
                        PRIMARY KEY (CodiceTessera),
                        FOREIGN KEY (Squadra) REFERENCES Squadra(Nome)
                      );

create table Caratteristiche(   CodiceGiocatore VARCHAR(7) PRIMARY KEY,
                                Altezza FLOAT,
                                Peso INT,
                                Ruolo VARCHAR(2) CHECK (Ruolo LIKE 'A' OR
                                                        Ruolo LIKE 'PG' OR
                                                        Ruolo LIKE 'SG' OR
                                                        Ruolo LIKE 'SF' OR
                                                        Ruolo LIKE 'PF' OR
                                                        Ruolo LIKE 'C'),
                                FOREIGN KEY (CodiceGiocatore) REFERENCES Tesserato(CodiceTessera)
                            );

create table Stagione(  Anno YEAR PRIMARY KEY,
                        Vincitore VARCHAR(20),
                        MVP VARCHAR(7),
                        Marcatore VARCHAR(7),
                        Assistman VARCHAR(7),
                        FOREIGN KEY (Vincitore) REFERENCES Squadra(Nome),
                        FOREIGN KEY (MVP) REFERENCES Tesserato(CodiceTessera),
                        FOREIGN KEY (Marcatore) REFERENCES Tesserato(CodiceTessera),
                        FOREIGN KEY (Assistman) REFERENCES Tesserato(CodiceTessera)
                     );

create table Arbitro(   NumPatentino VARCHAR(7) PRIMARY KEY,
                        Sezione VARCHAR(20) NOT NULL
                    );

create table Partita(   Stagione YEAR,
                        Giornata TINYINT,
                        SquadraCasa VARCHAR(20),
                        SquadraTrasferta VARCHAR(20) NOT NULL,
                        PuntiTrasferta SMALLINT NOT NULL,
                        PuntiCasa SMALLINT NOT NULL,
                        Data DATE,
                        Arbitro VARCHAR(7),
                        PRIMARY KEY (Stagione, Giornata, SquadraCasa),
                        FOREIGN KEY (SquadraTrasferta) REFERENCES Squadra(Nome),
                        FOREIGN KEY (SquadraCasa) REFERENCES Squadra(Nome),
                        FOREIGN KEY (Stagione) REFERENCES Stagione(Anno),
                        FOREIGN KEY (Arbitro) REFERENCES Arbitro(NumPatentino),
                        UNIQUE (SquadraTrasferta, SquadraCasa, Stagione, Giornata)
                    );

create table Statistiche(   CodiceGiocatore VARCHAR(7),
                            SquadraCasa VARCHAR(20) NOT NULL,
                            Anno YEAR NOT NULL,
                            Giornata TINYINT NOT NULL,
                            3PA TINYINT,
                            3PT TINYINT,
                            2PA TINYINT,
                            2PT TINYINT,
                            AST TINYINT,
                            BLK TINYINT,
                            REB TINYINT,
                            STL TINYINT,
                            PRIMARY KEY (CodiceGiocatore, SquadraCasa, Anno, Giornata),
                            FOREIGN KEY (SquadraCasa, Anno, Giornata) REFERENCES Partita(SquadraCasa, Stagione, Giornata),
                            FOREIGN KEY (CodiceGiocatore) REFERENCES Tesserato(CodiceTessera)
                        );

create view v_StatisticheStagionali as
    select T.Nome as Nome, T.Cognome as Cognome, T.Squadra as Squadra,
           2 * sum(S.2PT) + 3 * sum(S.3PT) as PTI,
           sum(2PT)/sum(2PA) * 100 as 2PP,
           sum(3PT)/sum(3PA) * 100 as 3PP,
           sum(AST) as AST, sum(BLK) as BLK, sum(STL) as STL, sum(REB) as REB,
           2*sum(2PT) - 0.75*sum(2PA) + 3*sum(3PT) - 0.84 * sum(3PA) + sum(AST) + sum(BLK) + sum(STL) + sum(REB) as SimplePER
    from Statistiche S
    inner join Tesserato T on S.CodiceGiocatore = T.CodiceTessera
    where T.Tipo = 'Giocatore'
    group by T.CodiceTessera;

create trigger trg_statisticheCorrette
BEFORE INSERT ON Statistiche
FOR EACH ROW BEGIN
    IF(NEW.3PT > NEW.3PA OR NEW.2PT > NEW.2PA)
    THEN signal sqlstate '45002' SET message_text = 'Non possono esserci più canestri segnati di quelli tentati';
END IF;
END;

create trigger trg_arbitroCorretto
BEFORE INSERT ON Partita
FOR EACH ROW BEGIN
IF ((select Sede from squadra
     where Nome = NEW.SquadraCasa) LIKE
    (select Sezione from arbitro
     where NumPatentino = NEW.Arbitro) OR
    (select Sede from squadra
     where Nome = NEW.SquadraTrasferta) LIKE
    (select Sezione from arbitro
     where NumPatentino = NEW.Arbitro))
THEN signal sqlstate '45001' SET message_text = 'Questo arbitro non può dirigere questa partita';
END IF;
END; -- NON SO PERCHE' IL FOR EACH ROW, COME SI FA UNO STATEMENT LEVEL TRIGGER?

create trigger trg_statisticheSoloSeGiocatore
BEFORE INSERT ON Caratteristiche
    FOR EACH ROW BEGIN
    IF (select Tipo from Tesserato
        where Tesserato.CodiceTessera = NEW.CodiceGiocatore) LIKE 'Allenatore'
    THEN signal sqlstate '45002' SET message_text = 'Non bisogna registrare caratteristiche degli arbitri';
    END IF;
end;

create trigger trg_Parita
BEFORE INSERT ON Partita
    FOR EACH ROW BEGIN
    IF(NEW.PuntiCasa = NEW.PuntiTrasferta)
    THEN signal sqlstate '45003' SET message_text = 'Una partita non può finire in parità';
    END IF;
end;

create procedure sp_stampaClassifica(IN Anno INT)
BEGIN
    select Squadra,sum(vittorie) as Vittorie
from
(
    select SquadraCasa as squadra, count(PuntiCasa) as vittorie from partita
    where PuntiCasa > PuntiTrasferta AND Stagione = Anno
    group by SquadraCasa
    union all
    select SquadraTrasferta as squadra, count(PuntiTrasferta) as vittorie from partita
    where PuntiTrasferta > PuntiCasa AND Stagione = Anno
    group by SquadraTrasferta
) as dati
group by squadra
order by Vittorie desc;
END;

create procedure sp_decretaVincitore(IN Anno INT)
BEGIN
        set @vincitore = (select squadra
            from (
                select SquadraCasa as squadra, count(PuntiCasa) as vittorie from partita
                where PuntiCasa > PuntiTrasferta AND Stagione = Anno
                group by SquadraCasa
                union all
                select SquadraTrasferta as squadra, count(PuntiTrasferta) as vittorie from partita
                where PuntiTrasferta > PuntiCasa AND Stagione = Anno
                group by SquadraTrasferta
            ) as dati
        group by squadra
        order by Vittorie desc
        limit 1);

        update Stagione
        set Vincitore = @vincitore
        where Stagione.Anno = Anno;
END;

create procedure sp_assegnaMVP(IN Edizione INT)
BEGIN
    set @mvp = (select codice from (select T.CodiceTessera as codice,
           2*sum(2PT) - 0.75*sum(2PA) + 3*sum(3PT) - 0.84 * sum(3PA) + sum(AST) + sum(BLK) + sum(STL) + sum(REB) as SimplePER
    from Statistiche S
    inner join Tesserato T on S.CodiceGiocatore = T.CodiceTessera
    where T.Tipo = 'Giocatore'
    group by T.CodiceTessera
    order by SimplePER desc
    limit 1) as Best);

    update Stagione
    set MVP = @mvp
    where Stagione.Anno = Edizione;
END;

create procedure sp_assegnaAssistman(IN Edizione INT)
BEGIN
    set @assistMan = (select Assistman from (select CodiceGiocatore as AssistMan, sum(AST) as AST
                from Statistiche S
                group by CodiceGiocatore
                order by AST desc
                limit 1) as best);

    update Stagione
    set Assistman = @assistMan
    where Stagione.Anno = Edizione;
END;

create procedure sp_assegnaMigliorMarcatore(IN Edizione INT)
BEGIN
    set @migliorMarcatore = (select migliorMarcatore from (select CodiceGiocatore as migliorMarcatore,
                2 * sum(S.2PT) + 3 * sum(S.3PT) as PTI
                from Statistiche S
                group by CodiceGiocatore
                order by PTI desc
    limit 1) as best);

    update Stagione
    set Marcatore = @migliorMarcatore
    where Stagione.Anno = Edizione;
END;

INSERT INTO squadra
VALUES ('Squadra1', 'Monfalcone');
INSERT INTO squadra
VALUES ('Squadra2', 'Trieste');
INSERT INTO squadra
VALUES ('Squadra3', 'Cervignano');
INSERT INTO squadra
VALUES ('Squadra4', 'Udine');
INSERT INTO squadra
VALUES ('Squadra5', 'Grado');
INSERT INTO squadra
VALUES ('Squadra6', 'Gorizia');
INSERT INTO squadra
VALUES ('Squadra7', 'Buttrio');

INSERT INTO tesserato
VALUES ('G000000','Antonio','Romano','2001-12-15','Giocatore', 3300,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000001','Andrea','Bianchi','1986-10-5','Giocatore', 2600,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000002','Riccardo','Martinelli','1988-8-18','Allenatore', 3100,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000003','Mauro','Galli','1986-4-8','Giocatore', 2300,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000004','Michele','Marini','1980-9-21','Giocatore', 3000,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000005','Michele','Longo','1983-2-28','Giocatore', 2700,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000006','Mauro','Galli','1986-10-4','Giocatore', 2000,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000007','Cristiano','Lombardi','1985-12-23','Giocatore', 3200,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000008','Matteo','Giordano','1997-2-19','Allenatore', 2200,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000009','Paolo','Galli','1999-3-25','Allenatore', 3600,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000010','Luca','Ricci','1991-7-9','Giocatore', 3300,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000011','Alessandro','Neri','2000-7-6','Giocatore', 3500,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000012','Luigi','Ricci','1984-3-20','Giocatore', 2700,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000013','Michele','Ricci','1993-10-16','Giocatore', 2300,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000014','Lorenzo','Longo','2001-9-21','Giocatore', 2300,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000015','Davide','Gatti','2001-9-18','Giocatore', 3100,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000016','Giacomo','Gallo','1981-4-5','Giocatore', 2000,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000017','Andrea','Russo','1993-9-21','Allenatore', 2800,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000018','Franco','Ferrara','1995-6-24','Allenatore', 2400,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000019','Andrea','Fontana','1986-11-17','Giocatore', 3700,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000020','Piero','Russo','1999-9-19','Giocatore', 2600,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000021','Matteo','Russo','1992-10-4','Allenatore', 2600,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000022','Matteo','Greco','1989-9-6','Giocatore', 2000,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000023','Matteo','Giordano','1981-4-1','Giocatore', 2400,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000024','Michele','Barbieri','1981-11-26','Giocatore', 2000,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000025','Francesco','Giordano','1997-3-5','Giocatore', 2900,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000026','Franco','Ricci','1984-2-15','Giocatore', 2100,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000027','Nicola','Moretto','1994-7-12','Allenatore', 3700,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000028','Sandro','Ricci','1983-9-14','Giocatore', 1900,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000029','Riccardo','Russo','1999-10-4','Giocatore', 1800,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000030','Federico','Ferrari','1984-1-27','Giocatore', 3000,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000031','Luigi','Giordano','1984-2-4','Giocatore', 2200,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000032','Piero','Neri','1989-3-7','Allenatore', 3300,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000033','Michele','Giordano','1983-2-21','Allenatore', 2400,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000034','Luca','Galli','1983-3-18','Giocatore', 2800,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000035','Francesco','Neri','1994-8-7','Allenatore', 2200,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000036','Pietro','Giordano','1994-9-17','Giocatore', 2100,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000037','Giulio','Martinelli','1992-3-28','Giocatore', 3600,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000038','Antonio','Colombo','1982-10-4','Giocatore', 2500,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000039','Paolo','Martini','1997-2-7','Giocatore', 2600,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000040','Franco','Ferrari','1994-7-4','Giocatore', 2900,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000041','Piero','Romano','1994-2-25','Giocatore', 2500,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000042','Giacomo','Romano','1987-12-22','Giocatore', 3300,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000043','Piero','Russo','1984-10-10','Giocatore', 2900,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000044','Riccardo','Longo','1995-1-9','Allenatore', 2900,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000045','Franco','Colombo','1989-9-16','Giocatore', 1900,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000046','Luigi','Galli','1985-4-6','Allenatore', 2700,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000047','Michele','Longo','1987-6-18','Allenatore', 2400,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000048','Davide','Fontana','1984-4-6','Giocatore', 2900,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000049','Piero','Martini','1980-6-17','Giocatore', 2300,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000050','Luigi','Lombardi','1983-2-17','Allenatore', 2300,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000051','Mauro','Lombardi','1984-8-18','Giocatore', 1800,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000052','Franco','Leone','1986-2-16','Giocatore', 1800,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000053','Cristiano','Fontana','1982-8-28','Allenatore', 3200,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000054','Lorenzo','Romano','1989-6-12','Giocatore', 1800,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000055','Giovanni','Giordano','1992-10-18','Giocatore', 3500,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000056','Luigi','Fossa','1995-5-20','Giocatore', 3600,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000057','Alessandro','Galli','1999-3-14','Allenatore', 1900,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000058','Davide','Bianchi','2001-5-1','Allenatore', 3500,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000059','Mauro','Rossi','1989-7-1','Giocatore', 3600,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000060','Michele','Neri','1993-4-28','Allenatore', 2100,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000061','Lorenzo','Colombo','1993-11-25','Giocatore', 3500,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000062','Paolo','Giordano','1999-5-5','Giocatore', 3400,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000063','Luigi','Neri','1999-12-25','Giocatore', 2400,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000064','Davide','Ferrara','1983-7-22','Giocatore', 2700,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000065','Riccardo','Verdi','1996-4-10','Giocatore', 3600,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000066','Giulio','Leone','1998-12-9','Giocatore', 3200,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000067','Paolo','Martinelli','1985-3-9','Allenatore', 3200,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000068','Matteo','Marini','2001-11-12','Giocatore', 1800,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000069','Riccardo','Fossa','1997-11-2','Giocatore', 3100,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000070','Sandro','Leone','1989-9-23','Giocatore', 2800,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000071','Piero','Marini','1999-6-21','Giocatore', 3100,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000072','Franco','Rossi','1996-10-23','Giocatore', 2500,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000073','Franco','Longo','1997-6-15','Giocatore', 3100,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000074','Michele','Russo','1982-8-21','Giocatore', 2700,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000075','Giovanni','Bianchi','1983-11-5','Giocatore', 2900,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000076','Alessandro','Romano','1986-6-24','Giocatore', 2800,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000077','Mauro','Rossi','1984-11-2','Giocatore', 3700,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000078','Antonio','Fossa','1997-9-25','Giocatore', 3200,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000079','Davide','Martini','1988-12-5','Giocatore', 2700,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000080','Piero','Gallo','2001-5-26','Giocatore', 2800,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000081','Antonio','Ferrara','1986-9-12','Giocatore', 2000,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000082','Lorenzo','Ricci','1987-4-5','Giocatore', 2800,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000083','Michele','Fossa','1987-8-5','Giocatore', 3600,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000084','Piero','Galli','1994-9-8','Giocatore', 3600,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000085','Pietro','Bianchi','1982-12-19','Giocatore', 3200,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000086','Cristiano','Longo','2000-2-8','Giocatore', 3300,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000087','Luca','Verdi','1993-7-12','Allenatore', 2500,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000088','Paolo','Romano','1982-1-28','Giocatore', 3700,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000089','Piero','Gatti','1997-4-9','Giocatore', 1800,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000090','Michele','Martinelli','1982-6-25','Giocatore', 2200,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000091','Andrea','Marini','1991-9-4','Giocatore', 3300,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000092','Francesco','Romano','1993-9-24','Giocatore', 2600,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000093','Nicola','Galli','1991-6-8','Allenatore', 3300,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000094','Francesco','Lombardi','1998-3-26','Giocatore', 3200,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000095','Riccardo','Russo','1992-7-9','Giocatore', 2800,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000096','Antonio','Russo','1987-6-6','Giocatore', 3500,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000097','Alessandro','Longo','1992-8-10','Giocatore', 2200,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000098','Mauro','Ricci','2001-3-21','Giocatore', 3400,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000099','Nicola','Ferrari','1991-8-5','Allenatore', 3100,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000100','Giulio','Martini','1983-2-25','Giocatore', 2500,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000101','Riccardo','Gatti','1984-12-9','Giocatore', 3200,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000102','Davide','Gallo','1993-1-28','Allenatore', 2100,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000103','Cristiano','Ferrara','1997-7-25','Giocatore', 3400,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000104','Luca','Greco','1985-3-8','Giocatore', 2000,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000105','Luigi','Gatti','1990-9-11','Giocatore', 3100,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000106','Davide','Costa','1992-10-14','Giocatore', 2300,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000107','Giulio','Ferrara','1989-2-21','Giocatore', 2700,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000108','Sandro','Russo','1982-8-25','Giocatore', 2200,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000109','Cristiano','Russo','1999-11-7','Giocatore', 2800,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000110','Nicola','Longo','1997-4-15','Allenatore', 3100,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000111','Mauro','Fossa','2000-4-1','Giocatore', 3600,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000112','Giulio','Neri','1984-5-27','Giocatore', 2900,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000113','Andrea','Ricci','1983-10-20','Giocatore', 2200,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000114','Andrea','Barbieri','1982-5-7','Giocatore', 2200,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000115','Federico','Galli','1984-6-21','Giocatore', 2500,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000116','Andrea','Gatti','1981-2-26','Giocatore', 3700,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000117','Mauro','Ricci','1994-10-4','Allenatore', 2600,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000118','Andrea','Greco','1996-3-9','Giocatore', 1900,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000119','Piero','Costa','1990-2-17','Giocatore', 3700,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000120','Marco','Leone','1986-11-14','Allenatore', 3300,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000121','Federico','Leone','1983-8-18','Giocatore', 3100,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000122','Giacomo','Barbieri','1992-8-3','Allenatore', 2700,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000123','Michele','Lombardi','1984-2-14','Allenatore', 2400,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000124','Sandro','Rossi','1981-5-11','Giocatore', 3300,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000125','Luigi','Neri','1988-10-6','Giocatore', 2600,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000126','Giacomo','Martinelli','1987-7-28','Giocatore', 3700,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000127','Francesco','Giordano','1998-12-18','Giocatore', 2300,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000128','Luca','Rossi','1985-2-28','Giocatore', 2500,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000129','Cristiano','Leone','1991-10-23','Allenatore', 1800,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000130','Sandro','Neri','1984-9-16','Giocatore', 2100,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000131','Lorenzo','Gallo','1995-6-2','Giocatore', 3700,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000132','Marco','Ricci','1997-8-19','Giocatore', 3100,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000133','Marco','Ferrara','1991-7-23','Giocatore', 3100,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000134','Federico','Neri','1986-4-27','Giocatore', 2800,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000135','Andrea','Leone','1999-7-3','Giocatore', 2600,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000136','Giacomo','Costa','1985-2-15','Giocatore', 3200,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000137','Alessandro','Giordano','1999-5-9','Giocatore', 3400,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000138','Mauro','Martinelli','1986-5-5','Giocatore', 2900,'2030-11-30','Squadra5');
INSERT INTO tesserato
VALUES ('G000139','Franco','Lombardi','1991-3-15','Giocatore', 2700,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000140','Francesco','Ferrari','1989-8-8','Giocatore', 2600,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000141','Alessandro','Greco','1995-4-1','Giocatore', 3000,'2030-11-30','Squadra3');
INSERT INTO tesserato
VALUES ('G000142','Alessandro','Ricci','1981-9-2','Giocatore', 2100,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000143','Andrea','Martini','1984-3-27','Giocatore', 2000,'2030-11-30','Squadra6');
INSERT INTO tesserato
VALUES ('G000144','Piero','Ricci','1995-3-14','Giocatore', 2000,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000145','Lorenzo','Greco','1981-5-11','Giocatore', 3100,'2030-11-30','Squadra1');
INSERT INTO tesserato
VALUES ('G000146','Mauro','Ferrara','1992-7-2','Giocatore', 3100,'2030-11-30','Squadra4');
INSERT INTO tesserato
VALUES ('G000147','Nicola','Martinelli','1991-1-28','Giocatore', 1900,'2030-11-30','Squadra2');
INSERT INTO tesserato
VALUES ('G000148','Davide','Verdi','2000-5-14','Giocatore', 1900,'2030-11-30','Squadra7');
INSERT INTO tesserato
VALUES ('G000149','Matteo','Martinelli','1990-6-19','Giocatore', 2600,'2030-11-30','Squadra6');

INSERT INTO stagione
VALUES(2010, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2011, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2012, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2013, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2014, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2015, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2016, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2017, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2018, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2019, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2020, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2021, NULL, NULL, NULL, NULL);
INSERT INTO stagione
VALUES(2022, NULL, NULL, NULL, NULL);

INSERT INTO arbitro
VALUES('A000000', 'Monfalcone');
INSERT INTO arbitro
VALUES('A000001', 'Romans');
INSERT INTO arbitro
VALUES('A000002', 'Trieste');
INSERT INTO arbitro
VALUES('A000003', 'Udine');
INSERT INTO arbitro
VALUES('A000004', 'Gorizia');
INSERT INTO arbitro
VALUES('A000005', 'Grado');
INSERT INTO arbitro
VALUES('A000006', 'Dolina');
INSERT INTO arbitro
VALUES('A000007', 'Pordenone');
INSERT INTO arbitro
VALUES('A000008', 'Sacile');
INSERT INTO arbitro
VALUES('A000009', 'Tarcento');
INSERT INTO arbitro
VALUES('A000010', 'Udine');
INSERT INTO arbitro
VALUES('A000011', 'Udine');
INSERT INTO arbitro
VALUES('A000012', 'Gorizia');
INSERT INTO arbitro
VALUES('A000013', 'Monfalcone');
INSERT INTO arbitro
VALUES('A000014', 'Trieste');
INSERT INTO arbitro
VALUES('A000015', 'Trieste');
INSERT INTO arbitro
VALUES('A000016', 'Monfalcone');
INSERT INTO arbitro
VALUES('A000017', 'Ronchi');
INSERT INTO arbitro
VALUES('A000018', 'Staranzano');
INSERT INTO arbitro
VALUES('A000019', 'Cervignano');

INSERT INTO caratteristiche
VALUES ('G000000','1.95','85','SF');
INSERT INTO caratteristiche
VALUES ('G000001','1.97','71','SF');
INSERT INTO caratteristiche
VALUES ('G000003','1.80','82','C');
INSERT INTO caratteristiche
VALUES ('G000004','1.97','92','SG');
INSERT INTO caratteristiche
VALUES ('G000005','1.91','70','SF');
INSERT INTO caratteristiche
VALUES ('G000006','1.83','80','C');
INSERT INTO caratteristiche
VALUES ('G000007','1.99','83','PG');
INSERT INTO caratteristiche
VALUES ('G000010','1.74','91','SF');
INSERT INTO caratteristiche
VALUES ('G000011','1.82','90','SF');
INSERT INTO caratteristiche
VALUES ('G000012','1.96','71','SF');
INSERT INTO caratteristiche
VALUES ('G000013','1.86','89','PG');
INSERT INTO caratteristiche
VALUES ('G000014','1.93','71','PG');
INSERT INTO caratteristiche
VALUES ('G000015','1.94','88','SF');
INSERT INTO caratteristiche
VALUES ('G000016','1.72','90','PF');
INSERT INTO caratteristiche
VALUES ('G000019','1.80','79','C');
INSERT INTO caratteristiche
VALUES ('G000020','1.87','99','PG');
INSERT INTO caratteristiche
VALUES ('G000022','1.95','97','PG');
INSERT INTO caratteristiche
VALUES ('G000023','1.80','89','PG');
INSERT INTO caratteristiche
VALUES ('G000024','1.78','74','SF');
INSERT INTO caratteristiche
VALUES ('G000025','2.01','91','SF');
INSERT INTO caratteristiche
VALUES ('G000026','2.08','96','SF');
INSERT INTO caratteristiche
VALUES ('G000028','1.86','84','SF');
INSERT INTO caratteristiche
VALUES ('G000029','2.03','84','C');
INSERT INTO caratteristiche
VALUES ('G000030','1.92','81','SF');
INSERT INTO caratteristiche
VALUES ('G000031','1.77','93','PG');
INSERT INTO caratteristiche
VALUES ('G000034','2.07','70','PF');
INSERT INTO caratteristiche
VALUES ('G000036','1.71','81','SG');
INSERT INTO caratteristiche
VALUES ('G000037','1.87','70','C');
INSERT INTO caratteristiche
VALUES ('G000038','1.88','81','SG');
INSERT INTO caratteristiche
VALUES ('G000039','1.88','79','SG');
INSERT INTO caratteristiche
VALUES ('G000040','1.93','71','SG');
INSERT INTO caratteristiche
VALUES ('G000041','1.78','89','SF');
INSERT INTO caratteristiche
VALUES ('G000042','2.05','75','PG');
INSERT INTO caratteristiche
VALUES ('G000043','2.09','85','SF');
INSERT INTO caratteristiche
VALUES ('G000045','1.87','88','PG');
INSERT INTO caratteristiche
VALUES ('G000048','1.83','95','SG');
INSERT INTO caratteristiche
VALUES ('G000049','1.92','77','SG');
INSERT INTO caratteristiche
VALUES ('G000051','1.74','99','C');
INSERT INTO caratteristiche
VALUES ('G000052','2.01','72','PF');
INSERT INTO caratteristiche
VALUES ('G000054','1.98','86','PF');
INSERT INTO caratteristiche
VALUES ('G000055','1.87','75','SG');
INSERT INTO caratteristiche
VALUES ('G000056','1.94','76','SF');
INSERT INTO caratteristiche
VALUES ('G000059','2.04','79','SG');
INSERT INTO caratteristiche
VALUES ('G000061','1.71','95','SG');
INSERT INTO caratteristiche
VALUES ('G000062','1.87','72','SG');
INSERT INTO caratteristiche
VALUES ('G000063','2.02','99','PF');
INSERT INTO caratteristiche
VALUES ('G000064','1.77','80','C');
INSERT INTO caratteristiche
VALUES ('G000065','1.82','97','C');
INSERT INTO caratteristiche
VALUES ('G000066','2.08','91','PF');
INSERT INTO caratteristiche
VALUES ('G000068','1.91','88','PG');
INSERT INTO caratteristiche
VALUES ('G000069','1.75','94','SG');
INSERT INTO caratteristiche
VALUES ('G000070','1.78','96','PG');
INSERT INTO caratteristiche
VALUES ('G000071','1.70','89','SG');
INSERT INTO caratteristiche
VALUES ('G000072','1.94','94','PG');
INSERT INTO caratteristiche
VALUES ('G000073','1.73','82','SG');
INSERT INTO caratteristiche
VALUES ('G000074','2.00','79','C');
INSERT INTO caratteristiche
VALUES ('G000075','1.77','99','PF');
INSERT INTO caratteristiche
VALUES ('G000076','1.83','90','SF');
INSERT INTO caratteristiche
VALUES ('G000077','1.75','93','PF');
INSERT INTO caratteristiche
VALUES ('G000078','1.71','86','PG');
INSERT INTO caratteristiche
VALUES ('G000079','2.07','76','C');
INSERT INTO caratteristiche
VALUES ('G000080','1.89','80','PG');
INSERT INTO caratteristiche
VALUES ('G000081','1.91','70','SF');
INSERT INTO caratteristiche
VALUES ('G000082','1.89','83','SF');
INSERT INTO caratteristiche
VALUES ('G000083','1.75','73','PF');
INSERT INTO caratteristiche
VALUES ('G000084','2.08','90','SF');
INSERT INTO caratteristiche
VALUES ('G000085','1.79','73','C');
INSERT INTO caratteristiche
VALUES ('G000086','1.93','91','PF');
INSERT INTO caratteristiche
VALUES ('G000088','1.78','99','SG');
INSERT INTO caratteristiche
VALUES ('G000089','1.90','73','C');
INSERT INTO caratteristiche
VALUES ('G000090','2.05','78','SG');
INSERT INTO caratteristiche
VALUES ('G000091','2.09','97','SG');
INSERT INTO caratteristiche
VALUES ('G000092','1.72','70','PG');
INSERT INTO caratteristiche
VALUES ('G000094','1.82','73','SF');
INSERT INTO caratteristiche
VALUES ('G000095','1.72','92','PG');
INSERT INTO caratteristiche
VALUES ('G000096','2.01','82','SF');
INSERT INTO caratteristiche
VALUES ('G000097','2.06','82','PF');
INSERT INTO caratteristiche
VALUES ('G000098','2.10','70','C');
INSERT INTO caratteristiche
VALUES ('G000100','1.92','83','SG');
INSERT INTO caratteristiche
VALUES ('G000101','1.75','93','SF');
INSERT INTO caratteristiche
VALUES ('G000103','1.81','82','SG');
INSERT INTO caratteristiche
VALUES ('G000104','1.92','75','PF');
INSERT INTO caratteristiche
VALUES ('G000105','1.74','89','SF');
INSERT INTO caratteristiche
VALUES ('G000106','1.85','83','SF');
INSERT INTO caratteristiche
VALUES ('G000107','1.86','81','C');
INSERT INTO caratteristiche
VALUES ('G000108','1.88','93','SF');
INSERT INTO caratteristiche
VALUES ('G000109','1.82','87','PF');
INSERT INTO caratteristiche
VALUES ('G000111','1.85','94','SF');
INSERT INTO caratteristiche
VALUES ('G000112','2.05','82','PF');
INSERT INTO caratteristiche
VALUES ('G000113','1.78','76','PG');
INSERT INTO caratteristiche
VALUES ('G000114','2.09','84','SF');
INSERT INTO caratteristiche
VALUES ('G000115','1.82','96','SG');
INSERT INTO caratteristiche
VALUES ('G000116','1.92','86','PF');
INSERT INTO caratteristiche
VALUES ('G000118','1.76','89','C');
INSERT INTO caratteristiche
VALUES ('G000119','1.79','71','PF');
INSERT INTO caratteristiche
VALUES ('G000121','1.86','80','SF');
INSERT INTO caratteristiche
VALUES ('G000124','1.80','84','PF');
INSERT INTO caratteristiche
VALUES ('G000125','1.88','83','PF');
INSERT INTO caratteristiche
VALUES ('G000126','1.89','85','C');
INSERT INTO caratteristiche
VALUES ('G000127','1.93','92','PF');
INSERT INTO caratteristiche
VALUES ('G000128','1.84','74','SG');
INSERT INTO caratteristiche
VALUES ('G000130','2.06','81','PF');
INSERT INTO caratteristiche
VALUES ('G000131','2.05','92','PF');
INSERT INTO caratteristiche
VALUES ('G000132','1.83','88','PG');
INSERT INTO caratteristiche
VALUES ('G000133','2.05','79','C');
INSERT INTO caratteristiche
VALUES ('G000134','1.77','86','SF');
INSERT INTO caratteristiche
VALUES ('G000135','1.97','98','SF');
INSERT INTO caratteristiche
VALUES ('G000136','1.85','71','SG');
INSERT INTO caratteristiche
VALUES ('G000137','1.88','74','PF');
INSERT INTO caratteristiche
VALUES ('G000138','2.06','89','PF');
INSERT INTO caratteristiche
VALUES ('G000139','1.83','99','PF');
INSERT INTO caratteristiche
VALUES ('G000140','1.78','87','SF');
INSERT INTO caratteristiche
VALUES ('G000141','1.74','73','PG');
INSERT INTO caratteristiche
VALUES ('G000142','1.93','71','PG');
INSERT INTO caratteristiche
VALUES ('G000143','2.05','72','C');
INSERT INTO caratteristiche
VALUES ('G000144','2.04','98','SF');
INSERT INTO caratteristiche
VALUES ('G000145','2.07','78','SG');
INSERT INTO caratteristiche
VALUES ('G000146','2.00','77','SF');
INSERT INTO caratteristiche
VALUES ('G000147','2.07','87','C');
INSERT INTO caratteristiche
VALUES ('G000148','1.71','77','C');
INSERT INTO caratteristiche
VALUES ('G000149','1.89','83','SG');

-- ANDATA --
INSERT INTO partita
VALUES (2022, 1, 'Squadra1', 'Squadra2', 110, 97, '2022-2-1', 'A000001');
INSERT INTO partita
VALUES (2022, 1, 'Squadra3', 'Squadra4', 154, 132, '2022-2-1', 'A000005');
INSERT INTO partita
VALUES (2022, 1, 'Squadra5', 'Squadra6', 97, 94, '2022-2-1', 'A000002');
INSERT INTO partita
VALUES (2022, 2, 'Squadra1', 'Squadra3', 110, 109, '2022-3-1', 'A000004');
INSERT INTO partita
VALUES (2022, 2, 'Squadra2', 'Squadra5', 102, 97, '2022-3-1', 'A000003');
INSERT INTO partita
VALUES (2022, 2, 'Squadra4', 'Squadra6', 110, 123, '2022-3-1', 'A000019');
INSERT INTO partita
VALUES (2022, 3, 'Squadra1', 'Squadra4', 108, 104, '2022-4-1', 'A000006');
INSERT INTO partita
VALUES (2022, 3, 'Squadra2', 'Squadra6', 103, 102, '2022-4-1', 'A000000');
INSERT INTO partita
VALUES (2022, 3, 'Squadra3', 'Squadra5', 104, 97, '2022-4-1', 'A000003');
INSERT INTO partita
VALUES (2022, 4, 'Squadra1', 'Squadra5', 124, 88, '2022-5-1', 'A000004');
INSERT INTO partita
VALUES (2022, 4, 'Squadra2', 'Squadra4', 120, 113, '2022-5-1', 'A000007');
INSERT INTO partita
VALUES (2022, 4, 'Squadra3', 'Squadra6', 108, 104, '2022-5-1', 'A000008');
INSERT INTO partita
VALUES (2022, 5, 'Squadra1', 'Squadra6', 90, 98, '2022-6-1', 'A000009');
INSERT INTO partita
VALUES (2022, 5, 'Squadra2', 'Squadra3', 98, 97, '2022-6-1', 'A000011');
INSERT INTO partita
VALUES (2022, 5, 'Squadra4', 'Squadra5', 77, 78, '2022-6-1', 'A000012');

-- RITORNO --
INSERT INTO partita
VALUES (2022, 6, 'Squadra2', 'Squadra1', 74, 97, '2022-7-1', 'A000011');
INSERT INTO partita
VALUES (2022, 6, 'Squadra4', 'Squadra3', 113, 132, '2022-7-1', 'A000001');
INSERT INTO partita
VALUES (2022, 6, 'Squadra6', 'Squadra5', 99, 100, '2022-7-1', 'A000002');
INSERT INTO partita
VALUES (2022, 7, 'Squadra3', 'Squadra1', 98, 103, '2022-8-1', 'A000003');
INSERT INTO partita
VALUES (2022, 7, 'Squadra5', 'Squadra2', 104, 97, '2022-8-1', 'A000004');
INSERT INTO partita
VALUES (2022, 7, 'Squadra6', 'Squadra4', 108, 104, '2022-8-1', 'A000001');
INSERT INTO partita
VALUES (2022, 8, 'Squadra4', 'Squadra1', 105, 98, '2022-9-1', 'A000005');
INSERT INTO partita
VALUES (2022, 8, 'Squadra6', 'Squadra2', 97, 94, '2022-9-1', 'A000006');
INSERT INTO partita
VALUES (2022, 8, 'Squadra5', 'Squadra3', 110, 105, '2022-9-1', 'A000007');
INSERT INTO partita
VALUES (2022, 9, 'Squadra5', 'Squadra1', 110, 109, '2022-10-1', 'A000008');
INSERT INTO partita
VALUES (2022, 9, 'Squadra4', 'Squadra2', 94, 96, '2022-10-1', 'A000009');
INSERT INTO partita
VALUES (2022, 9, 'Squadra6', 'Squadra3', 84, 87, '2022-10-1', 'A000007');
INSERT INTO partita
VALUES (2022, 10, 'Squadra6', 'Squadra1', 78, 87, '2022-11-1', 'A000005');
INSERT INTO partita
VALUES (2022, 10, 'Squadra3', 'Squadra2', 102, 103, '2022-11-1', 'A000004');
INSERT INTO partita
VALUES (2022, 10, 'Squadra5', 'Squadra4', 110, 109, '2022-11-1', 'A000001');


INSERT INTO Statistiche
VALUES ('G000010', 'Squadra1', 2022, 1, 12, 11, 11, 10, 3, 0, 1, 2);
INSERT INTO Statistiche
VALUES ('G000015', 'Squadra1', 2022, 1, 8, 5, 0, 0, 6, 2, 2, 3);
INSERT INTO Statistiche
VALUES ('G000029', 'Squadra1', 2022, 1, 7, 4, 2, 2, 4, 5, 2, 1);
INSERT INTO Statistiche
VALUES ('G000006', 'Squadra1', 2022, 1, 5, 4, 3, 3, 3, 4, 5, 5);
INSERT INTO Statistiche
VALUES ('G000007', 'Squadra1', 2022, 1, 8, 6, 5, 3, 5, 4, 2, 3);
INSERT INTO Statistiche
VALUES ('G000003', 'Squadra3', 2022, 1, 7, 6, 9, 8, 5, 2, 8, 4);
INSERT INTO Statistiche
VALUES ('G000004', 'Squadra3', 2022, 1, 15, 3, 11, 10, 3, 0, 5, 3);
INSERT INTO Statistiche
VALUES ('G000008', 'Squadra3', 2022, 1, 7, 4, 2, 2, 3, 2, 6, 1);
INSERT INTO Statistiche
VALUES ('G000022', 'Squadra3', 2022, 1, 8, 3, 0, 0, 3, 5, 4, 1);
INSERT INTO Statistiche
VALUES ('G000002', 'Squadra5', 2022, 1, 4, 3, 4, 2, 3, 8, 3, 0);
INSERT INTO Statistiche
VALUES ('G000005', 'Squadra5', 2022, 1, 9, 5, 5, 3, 3, 7, 2, 4);
INSERT INTO Statistiche
VALUES ('G000000', 'Squadra5', 2022, 1, 9, 8, 5, 3, 3, 5, 8, 2);
INSERT INTO Statistiche
VALUES ('G000009', 'Squadra5', 2022, 1, 6, 5, 3, 2, 3, 3, 4, 1);
INSERT INTO Statistiche
VALUES ('G000013', 'Squadra5', 2022, 1, 3, 3, 1, 0, 3, 2, 5, 0);


CALL sp_decretaVincitore(2022);
CALL sp_assegnaMVP(2022);
CALL sp_assegnaAssistman(2022);
CALL sp_assegnaMigliorMarcatore(2022);

select t.Nome, t.Cognome, t.Squadra, max(3 * s1.3PT + 2 * s1.2PT) as Punti from statistiche s1
inner join tesserato t on s1.CodiceGiocatore = t.CodiceTessera
group by t.Squadra;

select t.Nome, t.Cognome, c.Altezza, c.Peso, (c.Peso / (c.Altezza * c.Altezza)) as BMI from tesserato t
inner join caratteristiche c on t.CodiceTessera = c.CodiceGiocatore
order by BMI desc;