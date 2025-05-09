CREATE DATABASE SMA;
USE SMA;

SELECT * FROM Faculty;
SELECT * FROM Pulpit;
SELECT * FROM Teacher;
SELECT * FROM Subject;


drop table FACULTY;
drop table Pulpit;
drop table Teacher;
drop table Subject;

delete from FACULTY;
delete from Pulpit;
delete from Teacher where teacher = '?';
delete from Subject;

CREATE TABLE Faculty (
    faculty NVARCHAR(50) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

CREATE TABLE Pulpit (
    pulpit NVARCHAR(50) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    faculty NVARCHAR(50) NOT NULL,
    FOREIGN KEY (faculty) REFERENCES Faculty(faculty) ON DELETE CASCADE
);

CREATE TABLE Teacher (
    teacher NVARCHAR(50) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    pulpit NVARCHAR(50) NOT NULL,
    FOREIGN KEY (pulpit) REFERENCES Pulpit(pulpit) ON DELETE CASCADE
);

CREATE TABLE Subject (
    subject NVARCHAR(50) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    pulpit NVARCHAR(50) NOT NULL,
    FOREIGN KEY (pulpit) REFERENCES Pulpit(pulpit) ON DELETE CASCADE
);

INSERT INTO Faculty (faculty, name) VALUES
(N'ИДиП',   N'Издателькое дело и полиграфия'),
(N'ХТиТ',   N'Химическая технология и техника'),
(N'ЛХФ',    N'Лесохозяйственный факультет'),
(N'ИЭФ',    N'Инженерно-экономический факультет'),
(N'ТТЛП',   N'Технология и техника лесной промышленности'),
(N'ТОВ',    N'Технология органических веществ');
select * from faculty;
INSERT INTO Pulpit (pulpit, name, faculty) VALUES 
(N'ИСиТ',    N'Информационных систем и технологий ',                         N'ИДиП'  ),
(N'ПОиСОИ', N'Полиграфического оборудования и систем обработки информации ', N'ИДиП'  ),
(N'ЛВ',      N'Лесоводства',                                                 N'ЛХФ'),
(N'ОВ',      N'Охотоведения',                                                 N'ЛХФ'),   
(N'ЛУ',      N'Лесоустройства',                                              N'ЛХФ'),    
(N'ЛЗиДВ',   N'Лесозащиты и древесиноведения',                               N'ЛХФ'),  
(N'ЛПиСПС',  N'Ландшафтного проектирования и садово-паркового строительства', N'ЛХФ'),            
(N'ТЛ',     N'Транспорта леса',                                              N'ТТЛП'),                        
(N'ЛМиЛЗ',  N'Лесных машин и технологии лесозаготовок',                      N'ТТЛП'),    
(N'ОХ',     N'Органической химии',                                           N'ТОВ'),           
(N'ТНХСиППМ',N'Технологии нефтехимического синтеза и переработки полимерных материалов',N'ТОВ'),
(N'ТНВиОХТ',N'Технологии неорганических веществ и общей химической технологии ',N'ХТиТ'),                   
(N'ХТЭПиМЭЕ',N'Химии, технологии электрохимических производств и материалов электронной техники', N'ХТиТ'),
(N'ЭТиМ',    N'экономической теории и маркетинга',                              N'ИЭФ'),
(N'МиЭП',   N'Менеджмента и экономики природопользования', N'ИЭФ'); 

INSERT INTO TEACHER (TEACHER, NAME, PULPIT) VALUES
(N'СМЛВ', N'Смелов Владимир Владиславович', N'ИСиТ'),
(N'АКНВЧ', N'Акунович Станислав Иванович', N'ИСиТ'),
(N'КЛСНВ', N'Колесников Леонид Валерьевич', N'ИСиТ'),
(N'ГРМН', N'Герман Олег Витольдович', N'ИСиТ'),
(N'ЛЩНК', N'Лащенко Анатолий Пвалович', N'ИСиТ'),
(N'БРКВЧ', N'Бракович Андрей Игорьевич', N'ИСиТ'),
(N'ДДК', N'Дедко Александр Аркадьевич', N'ИСиТ'),
(N'КБЛ', N'Кабайло Александр Серафимович', N'ИСиТ'),
(N'УРБ', N'Урбанович Павел Павлович', N'ИСиТ'),
(N'РМНК', N'Романенко Дмитрий Михайлович', N'ИСиТ'),
(N'ПСТВЛВ', N'Пустовалова Наталия Николаевна', N'ИСиТ'),
(N'?', N'Неизвестный', N'ИСиТ'),
(N'ГРН', N'Гурин Николай Иванович', N'ИСиТ'),
(N'ЖЛК', N'Жиляк Надежда Александровна', N'ИСиТ'),
(N'БРТШВЧ', N'Барташевич Святослав Александрович', N'ПОиСОИ'),
(N'ЮДНКВ', N'Юденков Виктор Степанович', N'ПОиСОИ'),
(N'БРНВСК', N'Барановский Станислав Иванович', N'ЭТиМ'),
(N'НВРВ', N'Неверов Александр Васильевич', N'МиЭП'),
(N'РВКЧ', N'Ровкач Андрей Иванович', N'ОВ'),
(N'ДМДК', N'Демидко Марина Николаевна', N'ЛПиСПС'),
(N'МШКВСК', N'Машковский Владимир Петрович', N'ЛУ'),
(N'ЛБХ', N'Лабоха Константин Валентинович', N'ЛВ'),
(N'ЗВГЦВ', N'Звягинцев Вячеслав Борисович', N'ЛЗиДВ'), 
(N'БЗБРДВ', N'Безбородов Владимир Степанович', N'ОХ'), 
(N'ПРКПЧК', N'Прокопчук Николай Романович', N'ТНХСиППМ'), 
(N'НСКВЦ', N'Насковец Михаил Трофимович', N'ТЛ'), 
(N'МХВ', N'Мохов Сергей Петрович', N'ЛМиЛЗ'), 
(N'ЕЩНК', N'Ещенко Людмила Семеновна', N'ТНВиОХТ'), 
(N'ЖРСК', N'Жарский Иван Михайлович', N'ХТЭПиМЭЕ');

INSERT INTO Subject (subject, name, pulpit) VALUES
(N'СУБД', N'Системы управления базами данных', N'ИСиТ'),
(N'БД', N'Базы данных', N'ИСиТ'),
(N'ИНФ', N'Информационные технологии', N'ИСиТ'),
(N'ОАиП', N'Основы алгоритмизации и программирования', N'ИСиТ'),
(N'ПЗ', N'Представление знаний в компьютерных системах', N'ИСиТ'),
(N'ПСП', N'Программирование сетевых приложений', N'ИСиТ'),
(N'МСОИ', N'Моделирование систем обработки информации', N'ИСиТ'),
(N'ПИС', N'Проектирование информационных систем', N'ИСиТ'),
(N'КГ', N'Компьютерная геометрия', N'ИСиТ'),
(N'ПМАПЛ', N'Полиграфические машины, автоматы и поточные линии', N'ПОиСОИ'),
(N'КМС', N'Компьютерные мультимедийные системы', N'ИСиТ'),
(N'ОПП', N'Организация полиграфического производства', N'ПОиСОИ'),
(N'ДМ', N'Дискретная математика', N'ИСиТ'),
(N'МП', N'Математическое программирование', N'ИСиТ'),
(N'ЛЭВМ', N'Логические основы ЭВМ', N'ИСиТ'),
(N'ООП', N'Объектно-ориентированное программирование', N'ИСиТ'),
(N'ЭП', N'Экономика природопользования', N'МиЭП'),
(N'ЭТ', N'Экономическая теория', N'ЭТиМ'),
(N'БЛЗиПсOO', N'Биология лесных зверей и птиц с осн. охотов.', N'ОВ'),
(N'ОСПиЛПХ', N'Основы садовопаркового и лесопаркового хозяйства', N'ЛПиСПС'),
(N'ИГ', N'Инженерная геодезия', N'ЛУ'),
(N'ЛВ', N'Лесоводство', N'ЛЗиДВ'),
(N'ОХ', N'Органическая химия', N'ОХ'),
(N'ТРИ', N'Технология резиновых изделий', N'ТНХСиППМ'),
(N'ВТЛ', N'Водный транспорт леса', N'ТЛ'),
(N'ТиОЛ', N'Технология и оборудование лесозаготовок', N'ЛМиЛЗ'),
(N'ТОПИ', N'Технология обогащения полезных ископаемых', N'ТНВиОХТ'),
(N'ПЭХ', N'Прикладная электрохимия', N'ХТЭПиМЭЕ');

select * from Faculty