#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ДвиженияДокумента

Процедура ИнициализироватьТаблицыДляДвижений(ДокументОбъект) Экспорт

	ТаблицаПланированиеБюджета = ИнициализироватьТаблицуДвиженийПланированиеБюджета(ДокументОбъект);

	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ТаблицаПланированиеБюджета", ТаблицаПланированиеБюджета);

	ДокументОбъект.ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", СтруктураРезультата);

КонецПроцедуры

Процедура ОтразитьДвиженияПланированиеБюджета(Документ, Отказ) Экспорт

	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПланированиеБюджета;

	Если Отказ Или ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ДвиженияПланированиеБюджета = Документ.Движения.ПланированиеБюджета;
	ДвиженияПланированиеБюджета.Записывать = Истина;
	ДвиженияПланированиеБюджета.Загрузить(ТаблицаДвижений);

КонецПроцедуры

// Инициализирует таблицу движений по регистру "ПланированиеБюджета"
// 
// Параметры:
// 	ДокументОбъект - ДокументОбъект.ПланированиеБюджета - Регистратор
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание:
// * Регистратор 
// * Период 
// * ВидДвижения 
// * СтатьяДоходовРасходов 
// * Сумма 
// * СуммаБюджетНаДень 
Функция ИнициализироватьТаблицуДвиженийПланированиеБюджета(ДокументОбъект)

	ТаблицаДвижений = НоваяТаблицаДвиженийПланированиеБюджета();

	ДатаСч = ДокументОбъект.НачалоПериода;

	Пока ДатаСч <= ДокументОбъект.КонецПериода Цикл

		НоваяСтрока = ТаблицаДвижений.Добавить();
		НоваяСтрока.Период = ДатаСч;
		НоваяСтрока.Регистратор = ДокументОбъект.Ссылка;

		ДатаСч = ДатаСч + 86400;

	КонецЦикла;

	ТаблицаДвижений.ЗаполнитьЗначения(ДокументОбъект.СуммаБюджетНаДень, "СуммаБюджетНаДень");
	
	// Дополним движениями по доходам/расходам. Кидаем всё на первый день периода
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПланированиеБюджетаДоходы.Ссылка КАК Регистратор,
	|	ПланированиеБюджетаДоходы.Ссылка.НачалоПериода КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ПланированиеБюджетаДоходы.СтатьяДоходов КАК СтатьяДоходовРасходов,
	|	ПланированиеБюджетаДоходы.Сумма КАК Сумма
	|ПОМЕСТИТЬ ДвиженияДетально
	|ИЗ
	|	Документ.ПланированиеБюджета.Доходы КАК ПланированиеБюджетаДоходы
	|ГДЕ
	|	ПланированиеБюджетаДоходы.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПланированиеБюджетаРасходы.Ссылка,
	|	ПланированиеБюджетаРасходы.ДатаРасхода,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ПланированиеБюджетаРасходы.СтатьяРасходов,
	|	ПланированиеБюджетаРасходы.Сумма КАК Сумма
	|ИЗ
	|	Документ.ПланированиеБюджета.Расходы КАК ПланированиеБюджетаРасходы
	|ГДЕ
	|	ПланированиеБюджетаРасходы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвиженияДетально.Регистратор,
	|	ДвиженияДетально.Период,
	|	ДвиженияДетально.ВидДвижения,
	|	ДвиженияДетально.СтатьяДоходовРасходов,
	|	СУММА(ДвиженияДетально.Сумма) КАК Сумма
	|ИЗ
	|	ДвиженияДетально КАК ДвиженияДетально
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияДетально.Регистратор,
	|	ДвиженияДетально.Период,
	|	ДвиженияДетально.ВидДвижения,
	|	ДвиженияДетально.СтатьяДоходовРасходов";

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл

		НоваяСтрока = ТаблицаДвижений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);

	КонецЦикла;

	Возврат ТаблицаДвижений;

КонецФункции

// Подготавливает таблицу для формирования движений по регистру "ПланированиеБюджета"
// 
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание:
// * Регистратор 
// * Период 
// * ВидДвижения 
// * СтатьяДоходовРасходов 
// * Сумма 
// * СуммаБюджетНаДень 
Функция НоваяТаблицаДвиженийПланированиеБюджета()

	ТаблицаДвижений = Новый ТаблицаЗначений;
	ТаблицаДвижений.Колонки.Добавить("Регистратор");
	ТаблицаДвижений.Колонки.Добавить("Период");
	ТаблицаДвижений.Колонки.Добавить("ВидДвижения");
	ТаблицаДвижений.Колонки.Добавить("СтатьяДоходовРасходов");
	ТаблицаДвижений.Колонки.Добавить("Сумма");
	ТаблицаДвижений.Колонки.Добавить("СуммаБюджетНаДень");

	Возврат ТаблицаДвижений;

КонецФункции

#КонецОбласти
#КонецЕсли