
Процедура ЗаполнитьТаблицуСозданияДокументов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеВыписки", ДанныеВыписки.Выгрузить());
	Запрос.УстановитьПараметр("Доход", Перечисления.ВидыДвиженийДенежныхСредств.Доход);
	Запрос.УстановитьПараметр("Расход", Перечисления.ВидыДвиженийДенежныхСредств.Расход);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеВыписки.ДатаОперации,
	|	ДанныеВыписки.ИдентификаторКарты,
	|	ДанныеВыписки.СуммаПлатежа,
	|	ДанныеВыписки.Категория,
	|	ДанныеВыписки.Описание
	|ПОМЕСТИТЬ ДанныеВыписки
	|ИЗ
	|	&ДанныеВыписки КАК ДанныеВыписки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИСТИНА КАК Обрабатывать,
	|	ДанныеВыписки.ДатаОперации КАК ДатаОперации,
	|	КошелькиИСчета.Ссылка КАК Кошелек,
	|	СоответствиеКатегорийИОписанийСтатьямЗатрат.СтатьяДоходовРасходов КАК СтатьяДоходовРасходов,
	|	СоответствиеКатегорийИОписанийСтатьямЗатрат.АналитикаДоходов КАК АналитикаДоходов,
	|	СоответствиеКатегорийИОписанийСтатьямЗатрат.АналитикаРасходов КАК АналитикаРасходов,
	|	ДанныеВыписки.СуммаПлатежа КАК Сумма,
	|	ДанныеВыписки.Описание КАК Содержание,
	|	ВЫБОР
	|		КОГДА ДанныеВыписки.СуммаПлатежа > 0
	|			ТОГДА &Доход
	|		ИНАЧЕ &Расход
	|	КОНЕЦ КАК ВидДвижения,
	|	ДанныеВыписки.Категория,
	|	ДанныеВыписки.Описание
	|ИЗ
	|	ДанныеВыписки КАК ДанныеВыписки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КошелькиИСчета КАК КошелькиИСчета
	|		ПО ДанныеВыписки.ИдентификаторКарты = КошелькиИСчета.ИдентификаторКошелька
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеКатегорийИОписанийСтатьямЗатрат КАК
	|			СоответствиеКатегорийИОписанийСтатьямЗатрат
	|		ПО ДанныеВыписки.Категория = СоответствиеКатегорийИОписанийСтатьямЗатрат.Категория
	|		И ДанныеВыписки.Описание = СоответствиеКатегорийИОписанийСтатьямЗатрат.Описание";
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	ТаблицаДляСозданияДокументов.Загрузить(ТаблицаДанных);
	
КонецПроцедуры

Процедура СформироватьДокументы() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДанных", ТаблицаДляСозданияДокументов.Выгрузить());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДанных.Обрабатывать,
	|	ТаблицаДанных.Кошелек,
	|	ТаблицаДанных.СтатьяДоходовРасходов,
	|	ТаблицаДанных.АналитикаДоходов,
	|	ТаблицаДанных.АналитикаРасходов,
	|	ВЫБОР
	|		КОГДА ТаблицаДанных.Сумма < 0
	|			ТОГДА -ТаблицаДанных.Сумма
	|		ИНАЧЕ ТаблицаДанных.Сумма
	|	КОНЕЦ КАК Сумма,
	|	ТаблицаДанных.Содержание,
	|	ТаблицаДанных.Категория,
	|	ТаблицаДанных.Описание,
	|	ТаблицаДанных.ВидДвижения,
	|	ТаблицаДанных.ДатаОперации
	|ПОМЕСТИТЬ ТаблицаДанных
	|ИЗ
	|	&ТаблицаДанных КАК ТаблицаДанных
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДанных.Обрабатывать,
	|	ТаблицаДанных.Кошелек,
	|	ТаблицаДанных.СтатьяДоходовРасходов,
	|	ТаблицаДанных.АналитикаДоходов,
	|	ТаблицаДанных.АналитикаРасходов,
	|	ТаблицаДанных.Сумма,
	|	ТаблицаДанных.Содержание,
	|	ТаблицаДанных.ВидДвижения КАК ВидДвижения,
	|	ТаблицаДанных.Категория,
	|	ТаблицаДанных.Описание,
	|	ТаблицаДанных.ДатаОперации
	|ИЗ
	|	ТаблицаДанных КАК ТаблицаДанных
	|ГДЕ
	|	ТаблицаДанных.Обрабатывать
	|ИТОГИ
	|ПО
	|	ВидДвижения";
	
	ВыборкаПоВидамДвижений = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоВидамДвижений.Следующий() Цикл
		
		Результат = СоздатьДокументДвиженияДС(ВыборкаПоВидамДвижений);
		
		НоваяСтрока = СозданныеДокументы.Добавить();
		НоваяСтрока.Документ = Результат.Документ;
		
	КонецЦикла;
	
	Если СохранитьСоответствия Тогда
		ВыборкаПоВидамДвижений.Сбросить();
		СохранитьСоответствияКатегорийИСтатейЗатрат(ВыборкаПоВидамДвижений);
	КонецЕсли;
	
КонецПроцедуры

Процедура СохранитьСоответствияКатегорийИСтатейЗатрат(ВыборкаПоВидамДвижений)	
	
	Пока ВыборкаПоВидамДвижений.Следующий() Цикл
		
		ВыборкаПоСтрокам = ВыборкаПоВидамДвижений.Выбрать();
		Пока ВыборкаПоСтрокам.Следующий() Цикл
			
			Если ПустаяСтрока(ВыборкаПоСтрокам.Категория)
				И ПустаяСтрока(ВыборкаПоСтрокам.Описание) Тогда					
				Продолжить;				
			КонецЕсли;
			
			МенеджерЗаписи = РегистрыСведений.СоответствиеКатегорийИОписанийСтатьямЗатрат.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ВыборкаПоСтрокам);
			МенеджерЗаписи.Записать();
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция СоздатьДокументДвиженияДС(ВыборкаПоВидамДвижений)

	ВидДвижения = ВыборкаПоВидамДвижений.ВидДвижения;
	
	Если ВидДвижения = Перечисления.ВидыДвиженийДенежныхСредств.Расход Тогда
		Возврат СоздатьДокументРасхода(ВыборкаПоВидамДвижений);
	Иначе
		ВызватьИсключение "Необрабатываемый вид движения: " + ВидДвижения; 
	КонецЕсли;

КонецФункции

Функция СоздатьДокументРасхода(ВыборкаПоВидамДвижений)
	
	Результат = Новый Структура("Успех, Документ, ОписаниеОшибки", Ложь, Неопределено, "");
	
	ДокументРасхода = Документы.РегистрацияРасходов.СоздатьДокумент();
	ДокументРасхода.Дата = ТекущаяДата();
	
	ВыборкаПоРасходам = ВыборкаПоВидамДвижений.Выбрать();
	
	Пока ВыборкаПоРасходам.Следующий() Цикл
		
		НоваяСтрока = ДокументРасхода.Расходы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоРасходам);
		НоваяСтрока.ИсточникОплаты = ВыборкаПоРасходам.Кошелек;
		НоваяСтрока.СтатьяРасходов = ВыборкаПоРасходам.СтатьяДоходовРасходов;
		НоваяСтрока.ДатаРасхода = ВыборкаПоРасходам.ДатаОперации;
		
	КонецЦикла;
	
	Попытка
		ДокументРасхода.Записать(РежимЗаписиДокумента.Проведение);
		Результат.Успех = Истина;
		Результат.Документ = ДокументРасхода.Ссылка;
	Исключение
		Результат.ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Результат;

КонецФункции