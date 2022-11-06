#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	мх_МобильныйИнтерфейс.ОбработкаПолученияФормы(ВидФормы,
												Параметры,
											 	ВыбраннаяФорма,
											 	ДополнительнаяИнформация,
											 	СтандартнаяОбработка,
											 	"Документ.мх_РегистрацияРасходов");	

КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция РасходСуществует(ПараметрыРасхода) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтатьяРасходов", ПараметрыРасхода.СтатьяРасходов);
	Запрос.УстановитьПараметр("АналитикаРасходов", ПараметрыРасхода.АналитикаРасходов);
	Запрос.УстановитьПараметр("Период", ПараметрыРасхода.ДатаОперации);
	Запрос.УстановитьПараметр("Кошелек", ПараметрыРасхода.Кошелек);
	Запрос.УстановитьПараметр("Сумма", ПараметрыРасхода.Сумма);
	Запрос.УстановитьПараметр("Регистратор", ПараметрыРасхода.Регистратор);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Расходы.НомерСтроки
	|ИЗ
	|	РегистрНакопления.мх_Расходы КАК Расходы
	|ГДЕ
	|	Расходы.Период = &Период
	|	И Расходы.СтатьяРасходов = &СтатьяРасходов
	|	И Расходы.АналитикаРасходов = &АналитикаРасходов
	|	И Расходы.Сумма = &Сумма
	|	И Расходы.Регистратор <> &Регистратор";

	РезультатЗапроса = Запрос.Выполнить();

	Возврат Не РезультатЗапроса.Пустой();

КонецФункции



// Создает документ "Регистрация расхода"
// 
// Параметры:
// 	ПараметрыРасхода - Структура
// - Обязательные параметры
// 	* Сумма - Число - Сумма расхода
// 	* Кошелек - СправочникСсылка.мх_КошелькиИСчета
//  * СтатьяРасходов - ПланВидовХарактеристикСсылка.мх_СтатьиРасходов
// - Необязательные параметры
// 	* ДатаОперации - Дата - Дата платежа. Если не указана, то используется текущая дата
// 	* АналитикаРасходов - Характеристика.мх_СтатьиРасходов - Аналитика расхода
// 	* Содержание - Строка - содержание операции
// Возвращаемое значение:
// 	Структура - Описание:
// * Успех - Булево - Результат создания документа
// * ОписаниеОшибки - Строка - Описание ошибки
Функция ДобавитьРасход(ПараметрыРасхода) Экспорт

	Результат = Новый Структура("Успех, ОписаниеОшибки", Истина, "");

	ТекущаяДата = ТекущаяДата();

	Если Не ПараметрыРасхода.Свойство("ДатаОперации") Тогда
		ПараметрыРасхода.Вставить("ДатаОперации", ТекущаяДата);
	КонецЕсли;

	ДокументРасхода = Документы.мх_РегистрацияРасходов.СоздатьДокумент();
	ДокументРасхода.Дата = ТекущаяДата;
	ЗаполнитьЗначенияСвойств(ДокументРасхода, ПараметрыРасхода);
	НоваяСтрока = ДокументРасхода.Расходы.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ПараметрыРасхода);

	Попытка
		ДокументРасхода.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Результат.Успех = Ложь;
		Результат.ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ДвиженияДокумента

Процедура ИнициализироватьТаблицыДляДвижений(ДокументОбъект) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1, 1, 1));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаРасходы.Ссылка КАК Регистратор,
	|	ТаблицаРасходы.ДатаОперации КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаРасходы.Кошелек КАК Кошелек,
	|	ТаблицаРасходы.Кошелек.Валюта КАК Валюта,
	|	СУММА(ТаблицаРасходы.Сумма) КАК Сумма
	|ИЗ
	|	Документ.мх_РегистрацияРасходов.Расходы КАК ТаблицаРасходы
	|ГДЕ
	|	ТаблицаРасходы.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРасходы.Кошелек,
	|	ТаблицаРасходы.Ссылка,
	|	ТаблицаРасходы.ДатаОперации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРасходы.Ссылка КАК Регистратор,
	|	ТаблицаРасходы.ДатаОперации КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаРасходы.НомерСтроки,
	|	ТаблицаРасходы.СтатьяРасходов КАК СтатьяДоходовРасходов,
	|	ТаблицаРасходы.Кошелек.Валюта КАК Валюта,
	|	ТаблицаРасходы.Сумма
	|ИЗ
	|	Документ.мх_РегистрацияРасходов.Расходы КАК ТаблицаРасходы
	|ГДЕ
	|	ТаблицаРасходы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРасходы.Ссылка КАК Регистратор,
	|	ТаблицаРасходы.ДатаОперации КАК Период,
	|	ТаблицаРасходы.НомерСтроки,
	|	ТаблицаРасходы.СтатьяРасходов КАК СтатьяРасходов,
	|	ТаблицаРасходы.АналитикаРасходов,
	|	ТаблицаРасходы.Содержание КАК Содержание,
	|	ТаблицаРасходы.Кошелек.Валюта КАК Валюта,
	|	ТаблицаРасходы.Сумма,
	|	ТаблицаРасходы.ВнеБюджета
	|ИЗ
	|	Документ.мх_РегистрацияРасходов.Расходы КАК ТаблицаРасходы
	|ГДЕ
	|	ТаблицаРасходы.Ссылка = &Ссылка";

	РезультатЗапроса = Запрос.ВыполнитьПакет();

	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ТаблицаДвиженияДенежныхСредств", РезультатЗапроса[0].Выгрузить());
	СтруктураРезультата.Вставить("ТаблицаДоходыРасходы", РезультатЗапроса[1].Выгрузить());
	СтруктураРезультата.Вставить("ТаблицаРасходы", РезультатЗапроса[2].Выгрузить());

	ДокументОбъект.ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", СтруктураРезультата);

КонецПроцедуры

Процедура ОтразитьДвиженияДенежныхСредств(Документ, Отказ) Экспорт

	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДвиженияДенежныхСредств;

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ДвиженияДенежныхСредств = Документ.Движения.мх_ДвиженияДенежныхСредств;
	ДвиженияДенежныхСредств.Записывать = Истина;
	ДвиженияДенежныхСредств.Загрузить(ТаблицаДвижений);

КонецПроцедуры

Процедура ОтразитьДвиженияДоходыРасходы(Документ, Отказ) Экспорт

	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыРасходы;

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ДвиженияДоходыРасходы = Документ.Движения.мх_ДоходыРасходы;
	ДвиженияДоходыРасходы.Записывать = Истина;
	ДвиженияДоходыРасходы.Загрузить(ТаблицаДвижений);

КонецПроцедуры

Процедура ОтразитьДвиженияРасходы(Документ, Отказ) Экспорт

	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРасходы;

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ДвиженияРасходы = Документ.Движения.мх_Расходы;
	ДвиженияРасходы.Записывать = Истина;
	ДвиженияРасходы.Загрузить(ТаблицаДвижений);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
