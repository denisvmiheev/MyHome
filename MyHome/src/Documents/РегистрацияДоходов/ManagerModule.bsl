
#Область ДвиженияДокумента

Процедура ИнициализироватьТаблицыДляДвижений(ДокументОбъект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));
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
	|	ТаблицаДоходы.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ТаблицаДвиженияДенежныхСредств"	, РезультатЗапроса[0].Выгрузить());
	СтруктураРезультата.Вставить("ТаблицаДоходыРасходы"				, РезультатЗапроса[1].Выгрузить());
	СтруктураРезультата.Вставить("ТаблицаДоходы"					, РезультатЗапроса[2].Выгрузить());
	
	ДокументОбъект.ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", СтруктураРезультата);
	
КонецПроцедуры

Процедура ОтразитьДвиженияДенежныхСредств(Документ, Отказ) Экспорт
	
	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДвиженияДенежныхСредств;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияДенежныхСредств = Документ.Движения.ДвиженияДенежныхСредств;
	ДвиженияДенежныхСредств.Записывать = Истина;
	ДвиженияДенежныхСредств.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры

Процедура ОтразитьДвиженияДоходыРасходы(Документ, Отказ) Экспорт

	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыРасходы;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияДоходыРасходы = Документ.Движения.ДоходыРасходы;
	ДвиженияДоходыРасходы.Записывать = Истина;
	ДвиженияДоходыРасходы.Загрузить(ТаблицаДвижений);
		
КонецПроцедуры

Процедура ОтразитьДвиженияДоходы(Документ, Отказ) Экспорт
	
	ТаблицаДвижений = Документ.ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходы;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияДоходы = Документ.Движения.Доходы;
	ДвиженияДоходы.Записывать = Истина;
	ДвиженияДоходы.Загрузить(ТаблицаДвижений);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти