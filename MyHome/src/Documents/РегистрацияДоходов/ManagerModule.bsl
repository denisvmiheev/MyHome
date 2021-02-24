#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	МобильныйИнтерфейс.ОбработкаПолученияФормы(ВидФормы,
												Параметры,
											 	ВыбраннаяФорма,
											 	ДополнительнаяИнформация,
											 	СтандартнаяОбработка,
											 	"Документ.РегистрацияДоходов");	

КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Создает документ "Регистрация дохода"
// 
// Параметры:
// 	ПараметрыРасхода - Структура
// - Обязательные параметры
// 	* Сумма - Число - Сумма дохода
// 	* Кошелек - СправочникСсылка.КошелькиИСчета
//  * СтатьяРасходов - ПланВидовХарактеристикСсылка.СтатьиДоходов
// - Необязательные параметры
// 	* ДатаОперации - Дата - Дата платежа. Если не указана, то используется текущая дата
// 	* АналитикаДоходов - Характеристика.СтатьиДоходов - Аналитика дохода
// 	* Содержание - Строка - содержание операции
// Возвращаемое значение:
// 	Структура - Описание:
// * Успех - Булево - Результат создания документа
// * ОписаниеОшибки - Строка - Описание ошибки
Функция ДобавитьДоход(ПараметрыДохода) Экспорт

	Результат = Новый Структура("Успех, ОписаниеОшибки", Истина, "");

	ТекущаяДата = ТекущаяДата();

	Если Не ПараметрыДохода.Свойство("ДатаОперации") Тогда
		ПараметрыДохода.Вставить("ДатаОперации", ТекущаяДата);
	КонецЕсли;

	ДокументДохода = Документы.РегистрацияДоходов.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(ДокументДохода, ПараметрыДохода);
	ДокументДохода.Дата = ТекущаяДата;
	НоваяСтрока = ДокументДохода.Доходы.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ПараметрыДохода);

	Попытка
		ДокументДохода.Записать(РежимЗаписиДокумента.Проведение);
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
	|	ТаблицаДоходы.Ссылка КАК Регистратор,
	|	ТаблицаДоходы.ДатаОперации КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДоходы.Кошелек КАК Кошелек,
	|	СУММА(ТаблицаДоходы.Сумма) КАК Сумма
	|ИЗ
	|	Документ.РегистрацияДоходов.Доходы КАК ТаблицаДоходы
	|ГДЕ
	|	ТаблицаДоходы.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДоходы.Кошелек,
	|	ТаблицаДоходы.Ссылка,
	|	ТаблицаДоходы.ДатаОперации,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДоходы.Ссылка КАК Регистратор,
	|	ТаблицаДоходы.ДатаОперации КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДоходы.НомерСтроки,
	|	ТаблицаДоходы.СтатьяДоходов КАК СтатьяДоходовРасходов,
	|	ТаблицаДоходы.Сумма
	|ИЗ
	|	Документ.РегистрацияДоходов.Доходы КАК ТаблицаДоходы
	|ГДЕ
	|	ТаблицаДоходы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДоходы.Ссылка КАК Регистратор,
	|	ТаблицаДоходы.ДатаОперации КАК Период,
	|	ТаблицаДоходы.НомерСтроки,
	|	ТаблицаДоходы.СтатьяДоходов КАК СтатьяДоходов,
	|	ТаблицаДоходы.АналитикаДоходов,
	|	ТаблицаДоходы.Содержание КАК Содержание,
	|	ТаблицаДоходы.Сумма
	|ИЗ
	|	Документ.РегистрацияДоходов.Доходы КАК ТаблицаДоходы
	|ГДЕ
	|	ТаблицаДоходы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДоходы.Ссылка КАК Регистратор,
	|	ТаблицаДоходы.ДатаОперации КАК Период,
	|	МИНИМУМ(ТаблицаДоходы.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаДоходы.СтатьяДоходов КАК СтатьяДоходовРасходов,
	|	СУММА(ТаблицаДоходы.Сумма) КАК СуммаБюджетНаДень
	|ИЗ
	|	Документ.РегистрацияДоходов.Доходы КАК ТаблицаДоходы
	|ГДЕ
	|	ТаблицаДоходы.Ссылка = &Ссылка
	|	И ТаблицаДоходы.ВнеплановыйДоход
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДоходы.Ссылка,
	|	ТаблицаДоходы.ДатаОперации,
	|	ТаблицаДоходы.СтатьяДоходов";

	РезультатЗапроса = Запрос.ВыполнитьПакет();

	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ТаблицаДвиженияДенежныхСредств"	, РезультатЗапроса[0].Выгрузить());
	СтруктураРезультата.Вставить("ТаблицаДоходыРасходы"				, РезультатЗапроса[1].Выгрузить());
	СтруктураРезультата.Вставить("ТаблицаДоходы"					, РезультатЗапроса[2].Выгрузить());
	СтруктураРезультата.Вставить("ТаблицаПланированиеБюджета"		, РезультатЗапроса[3].Выгрузить());

	ДокументОбъект.ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", СтруктураРезультата);

КонецПроцедуры

Процедура ОтразитьДвиженияДенежныхСредств(Документ, Отказ) Экспорт

	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДвиженияДенежныхСредств;

	Если Отказ Или ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ДвиженияДенежныхСредств = Документ.Движения.ДвиженияДенежныхСредств;
	ДвиженияДенежныхСредств.Записывать = Истина;
	ДвиженияДенежныхСредств.Загрузить(ТаблицаДвижений);

КонецПроцедуры

Процедура ОтразитьДвиженияДоходыРасходы(Документ, Отказ) Экспорт

	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыРасходы;

	Если Отказ Или ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ДвиженияДоходыРасходы = Документ.Движения.ДоходыРасходы;
	ДвиженияДоходыРасходы.Записывать = Истина;
	ДвиженияДоходыРасходы.Загрузить(ТаблицаДвижений);

КонецПроцедуры

Процедура ОтразитьДвиженияДоходы(Документ, Отказ) Экспорт

	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходы;

	Если Отказ Или ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ДвиженияДоходы = Документ.Движения.Доходы;
	ДвиженияДоходы.Записывать = Истина;
	ДвиженияДоходы.Загрузить(ТаблицаДвижений);

КонецПроцедуры

Процедура ОтразитьДвиженияПланированиеБюджета(Документ, Отказ) Экспорт

	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПланированиеБюджета;

	Если Отказ Или ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ДвиженияДоходы = Документ.Движения.ПланированиеБюджета;
	ДвиженияДоходы.Записывать = Истина;
	ДвиженияДоходы.Загрузить(ТаблицаДвижений);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли