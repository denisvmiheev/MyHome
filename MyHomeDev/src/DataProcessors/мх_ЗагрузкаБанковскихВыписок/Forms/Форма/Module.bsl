#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	НомерТекущегоШага = 1;
	МаксимальноеКоличествоШагов = 4;

	мх_СобытияФорм.ЗаполнитьКэшированныеЗначенияДляСвязиТиповДоходовРасходов(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Асинх Процедура ФайлДляЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Результат = Ждать ДиалогВыбора.ВыбратьАсинх();
	
	Если Результат = Неопределено Или Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Объект.ФайлДляЗагрузки = Результат[0];

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ШагНазад(Команда)
	ПерейтиНаШаг(-1);
КонецПроцедуры

&НаКлиенте
Процедура ШагВперед(Команда)

	Если НомерТекущегоШага = МаксимальноеКоличествоШагов Тогда
		Закрыть();
		Возврат;
	КонецЕсли;

	Если Не МожноПереходитьКСледующемуШагу() Тогда
		Возврат;
	КонецЕсли;

	ПерейтиНаШаг(1);

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДляСозданияВыделитьВсе(Команда)
	УстановитьОтметкуСтрокТаблицыДляСоздания(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДляСозданияСнятьОтметкуУВсех(Команда)
	УстановитьОтметкуСтрокТаблицыДляСоздания(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиНаШаг(Шаг)

	СледующийШаг = НомерТекущегоШага + Шаг;

	Если СледующийШаг > 0 Тогда
		Если СледующийШаг = 2 Тогда
			ПрочитатьФайлИЗаполнитьТаблицуДанных();
		ИначеЕсли СледующийШаг = 3 Тогда
			ЗаполнитьТаблицуСозданияДокументов();
		ИначеЕсли СледующийШаг = 4 Тогда
			СоздатьДокументыДвиженийДС();
		Иначе
		КонецЕсли;
	КонецЕсли;

	НомерТекущегоШага = СледующийШаг;

	ИмяСтраницы = "ГруппаШаг" + НомерТекущегоШага;
	Элементы.ГруппаШаги.ТекущаяСтраница = Элементы[ИмяСтраницы];

	УстановитьВидимостьКнопокШагов();

КонецПроцедуры

Процедура СоздатьДокументыДвиженийДС()

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.СформироватьДокументы();
	ЗначениеВРеквизитФормы(ОбработкаОбъект.СозданныеДокументы, "Объект.СозданныеДокументы");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСозданияДокументов()

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ЗаполнитьТаблицуСозданияДокументов();
	ЗначениеВРеквизитФормы(ОбработкаОбъект.ТаблицаДляСозданияДокументов, "Объект.ТаблицаДляСозданияДокументов");

КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлИЗаполнитьТаблицуДанных()

	Файл = Новый Файл(Объект.ФайлДляЗагрузки);
	ПараметрыФайла = Новый Структура("Имя, ПолноеИмя, ИмяБезРасширения, Расширение, Путь");
	ЗаполнитьЗначенияСвойств(ПараметрыФайла, Файл);
	ДанныеФайла = Новый ДвоичныеДанные(Объект.ФайлДляЗагрузки);
	АдресХранилищаФайла = ПоместитьВоВременноеХранилище(ДанныеФайла);

	ПрочитатьФайлИЗаполнитьТаблицуДанныхНаСервере(ПараметрыФайла);

КонецПроцедуры

Процедура ПрочитатьФайлИЗаполнитьТаблицуДанныхНаСервере(ПараметрыФайла)

	ПараметрыЧтения = Новый Структура;
	ПараметрыЧтения.Вставить("АдресХранилищаФайла", АдресХранилищаФайла);
	ПараметрыЧтения.Вставить("ПараметрыФайла", ПараметрыФайла);
	ПараметрыЧтения.Вставить("ВариантЗагрузки", Объект.ВариантЗагрузки);

	ТаблицаДанных = Обработки.мх_ЗагрузкаБанковскихВыписок.ПрочитатьДанныеФайла(ПараметрыЧтения);

	Объект.ДанныеВыписки.Загрузить(ТаблицаДанных);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКнопокШагов()

	Если НомерТекущегоШага = 1 Тогда
		Элементы.ШагВперед.Видимость = Истина;
		Элементы.ШагНазад.Видимость = Ложь;
		Элементы.ШагВперед.Заголовок = "Далее";
	ИначеЕсли НомерТекущегоШага = МаксимальноеКоличествоШагов Тогда
		Элементы.ШагВперед.Видимость = Истина;
		Элементы.ШагНазад.Видимость = Истина;
		Элементы.ШагВперед.Заголовок = "Завершить";
	Иначе
		Элементы.ШагВперед.Видимость = Истина;
		Элементы.ШагНазад.Видимость = Истина;
		Элементы.ШагВперед.Заголовок = "Далее";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция МожноПереходитьКСледующемуШагу()

	Если НомерТекущегоШага = 1 Тогда
		Возврат ВыполнитьПроверкиЗаполненияРеквизитовОбработки();
	КонецЕсли;

	Если НомерТекущегоШага = 3 Тогда
		Возврат ПроверитьЗаполнение();
	КонецЕсли;

	Возврат Истина;

КонецФункции

&НаКлиенте
Функция ВыполнитьПроверкиЗаполненияРеквизитовОбработки()

	НетОшибок = Истина;

	Если Не ЗначениеЗаполнено(Объект.ВариантЗагрузки) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указан вариант загрузки'"), , , "Объект.ВариантЗагрузки");
		НетОшибок = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Объект.ФайлДляЗагрузки) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указан файл выписки'") , "", "Объект.ФайлДляЗагрузки");
		НетОшибок = Ложь;
	КонецЕсли;

	Возврат НетОшибок;

КонецФункции

&НаКлиенте
Процедура УстановитьОтметкуСтрокТаблицыДляСоздания(Отметка)

	Для Каждого СтрокаТаблицы Из Объект.ТаблицаДляСозданияДокументов Цикл
		СтрокаТаблицы.Обрабатывать = Отметка;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДляСозданияДокументовПриАктивизацииЯчейки(Элемент)

	ИмяЯчейки = Элемент.ТекущийЭлемент.Имя;

	Если ИмяЯчейки = "ТаблицаДляСозданияДокументовСтатьяДоходовРасходов" Тогда

		ИдентификаторСтроки = Элементы.ТаблицаДляСозданияДокументов.ТекущаяСтрока;

		Если ИдентификаторСтроки = Неопределено Тогда
			Возврат;
		КонецЕсли;

		УстановитьОграничениеТипаДляЯчейкиСтатьиЗатрат(ИдентификаторСтроки);

	КонецЕсли
	;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОграничениеТипаДляЯчейкиСтатьиЗатрат(ИдентификаторСтроки)

	ДанныеСтроки = Объект.ТаблицаДляСозданияДокументов.НайтиПоИдентификатору(ИдентификаторСтроки);

	Если ДанныеСтроки.ВидДвижения = КэшированныеЗначения.ВидДвиженияДоход Тогда
		Элементы.ТаблицаДляСозданияДокументовСтатьяДоходовРасходов.ОграничениеТипа
		 = КэшированныеЗначения.ОграничениеТипаДоход;
	ИначеЕсли ДанныеСтроки.ВидДвижения = КэшированныеЗначения.ВидДвиженияРасход Тогда
		Элементы.ТаблицаДляСозданияДокументовСтатьяДоходовРасходов.ОграничениеТипа
		 = КэшированныеЗначения.ОграничениеТипаРасход;
	Иначе
		Элементы.ТаблицаДляСозданияДокументовСтатьяДоходовРасходов.ОграничениеТипа 
		= КэшированныеЗначения.ОграничениеТипаСтатьиЗатрат;
	КонецЕсли;

КонецПроцедуры
#КонецОбласти