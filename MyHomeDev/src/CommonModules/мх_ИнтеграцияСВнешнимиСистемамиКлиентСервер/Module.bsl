#Область ПрограммныйИнтерфейс

Функция ПрочитатьДанныеШтрихкодаЧека(Штрихкод) Экспорт

	Результат = Новый Структура("Успех, Штрихкод, СырыеДанные, Данные, ОписаниеОшибки", Истина, Штрихкод, "", "", "");

	СтруктураЧека = НоваяСтруктураДанныхЧека();
	ПрочитатьШтрихкодЧекаВСтруктуру(Штрихкод, СтруктураЧека);

	ДанныеСистемыПроверкиЧеков = мх_ИнтеграцияСВнешнимиСистемамиПовтИсп.ДанныеСистемыПроверкиЧеков();
	СтруктураЧека.token = ДанныеСистемыПроверкиЧеков.ТокенДоступа;

	РезультатЗапроса = ВыполнитьЗапросКСистемеПроверкиЧеков(ДанныеСистемыПроверкиЧеков, СтруктураЧека);

	Если Не РезультатЗапроса.Успех Тогда
		Результат.Успех = Ложь;
		Результат.ОписаниеОшибки = РезультатЗапроса.ТелоОшибки;
		Возврат Результат;
	КонецЕсли;

	Попытка
		Результат.СырыеДанные = РезультатЗапроса.Данные;
		Результат.Данные = ПрочитатьДанныеJSON(Результат.СырыеДанные);

		Если Результат.Данные.code <> 1 Тогда
			Результат.Успех = Ложь;
			Результат.ОписаниеОшибки = Результат.Данные.data;
		КонецЕсли;

	Исключение

		Результат.Успех = Ложь;
		Результат.ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());

	КонецПопытки;

	Возврат Результат;

КонецФункции

Функция ДанныеЧека(СчитанныеДанные) Экспорт
	
	// Процедура создана с перспективой использования различных сервисов
	// проверки чеков, и приведения результатов чтения чеков к единой структуре

	Результат = НоваяСтруктураРезультатаЧтенияЧека();

	Если Не СчитанныеДанные.Успех Тогда
		Возврат Результат;
	КонецЕсли;

	ТипЧисло = ОбщегоНазначенияКлиентСервер.ОписаниеТипаЧисло(15, 2);

	СчитанныеДанные.Данные.data.json.Свойство("datetime", Результат.Дата);
	СчитанныеДанные.Данные.data.json.Свойство("user", Результат.Организация);
	СчитанныеДанные.Данные.data.json.Свойство("userInn", Результат.ИНН);
	СчитанныеДанные.Данные.data.json.Свойство("totalSum", Результат.Сумма);

	Результат.Сумма = ТипЧисло.ПривестиЗначение(Результат.Сумма) / 100;
	Результат.Дата = ПреобразоватьСтрокуВДату(Результат.Дата);

	Товары = Новый Массив;
	СчитанныеДанные.Данные.data.json.Свойство("items", Товары);

	Если ТипЗнч(Товары) = Тип("Массив") Тогда

		Для Каждого СтрокаТовары Из Товары Цикл

			СтруктураСтроки = Новый Структура("Наименование, Цена, Количество, Сумма", "", 0, 0, 0);
			СтрокаТовары.Свойство("name", СтруктураСтроки.Наименование);
			СтрокаТовары.Свойство("sum", СтруктураСтроки.Сумма);
			СтрокаТовары.Свойство("price", СтруктураСтроки.Цена);
			СтрокаТовары.Свойство("quantity", СтруктураСтроки.Количество);

			СтруктураСтроки.Сумма = ТипЧисло.ПривестиЗначение(СтруктураСтроки.Сумма) / 100;
			СтруктураСтроки.Цена = ТипЧисло.ПривестиЗначение(СтруктураСтроки.Цена) / 100;

			Результат.Товары.Добавить(СтруктураСтроки);

		КонецЦикла;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ПроверкаЧеков


// Генерирует новую структуру результата чтения чека
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Товары - Массив - Товары
// * ИНН - Строка - ИНН
// * Организация - Строка - Организация
// * Сумма - Число - Сумма
// * Дата - Дата - Дата
Функция НоваяСтруктураРезультатаЧтенияЧека()

	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Дата", Дата(1, 1, 1));
	СтруктураДанных.Вставить("Сумма", 0);
	СтруктураДанных.Вставить("Организация", "");
	СтруктураДанных.Вставить("ИНН", "");
	СтруктураДанных.Вставить("Товары", Новый Массив);

	Возврат СтруктураДанных;

КонецФункции

Функция ВыполнитьЗапросКСистемеПроверкиЧеков(ДанныеВнешнейСистемы, СтруктураЧека)

#Если ВебКлиент Тогда
	ВызватьИсключение "Метод недоступен на веб-клиенте";
#Иначе
		Результат = Новый Структура("Успех, КодСостояния, ТелоОшибки, Данные", Истина, "", "", "", "");

		ЗащищенноеСоединение = Неопределено;

		Если ДанныеВнешнейСистемы.ЗащищенноеСоединение = Истина Тогда
			ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL;
		КонецЕсли;

		Попытка

			Соединение = Новый HTTPСоединение(ДанныеВнешнейСистемы.Сервер, ДанныеВнешнейСистемы.Порт, ДанныеВнешнейСистемы.Пользователь,
				ДанныеВнешнейСистемы.Пароль, , , ЗащищенноеСоединение, );

			ЗаголовкиЗапроса = Новый Соответствие;
			ЗаголовкиЗапроса.Вставить("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

			Запрос = Новый HTTPЗапрос(ДанныеВнешнейСистемы.АдресРесурса, ЗаголовкиЗапроса);
			ТелоЗапроса = СформироватьСтрокуТелаЗапросаПоДаннымЧека(СтруктураЧека);
			Запрос.УстановитьТелоИзСтроки(ТелоЗапроса);

			Ответ = Соединение.ОтправитьДляОбработки(Запрос);
			ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();

			Если Ответ.КодСостояния <> 200 Тогда
				Результат.Успех = Ложь;
				Результат.ТелоОшибки = ТелоОтвета;
			Иначе
				Результат.Данные = ТелоОтвета;
			КонецЕсли;

			Результат.КодСостояния = Ответ.КодСостояния;

		Исключение
			Результат.Успех = Ложь;
		//@skip-warning
			Результат.ТелоОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;

		Возврат Результат;
#КонецЕсли

КонецФункции

// Генерирует новую структуру данных чека для отправки запроса
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * token - Строка - Токен доступа к сервису
// * qr - Строка - Признак сканирования qr кода (0/1)
// * s - Строка - Сумма чека
// * n - Строка - Тип операции (Приход/Возврат прихода/Расход/Возврат расхода)
// * t - Строка - Дата и время
// * fp - Строка - Фискальный признак документа
// * fd - Строка - Номер фискального документа
// * fn - Строка - Номер фискального накопителя
Функция НоваяСтруктураДанныхЧека() Экспорт

	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("fn", "");
	СтруктураДанных.Вставить("fd", "");
	СтруктураДанных.Вставить("fp", "");
	СтруктураДанных.Вставить("t", "");
	СтруктураДанных.Вставить("n", "");
	СтруктураДанных.Вставить("s", "");
	СтруктураДанных.Вставить("qr", 0);
	СтруктураДанных.Вставить("token", "");

	Возврат СтруктураДанных;

КонецФункции

// Заполняет структуру чека по данным переданного штрихкода
// 
// Параметры:
// 	Штрихкод - Строка - Данные штрихкода
// 	СтруктураЧека - Структура - Заполняемая структура. См. процедуру "НоваяСтруктураДанныхЧека"
Процедура ПрочитатьШтрихкодЧекаВСтруктуру(Штрихкод, СтруктураЧека = Неопределено) Экспорт

	Если СтруктураЧека = Неопределено Тогда
		СтруктураЧека = НоваяСтруктураДанныхЧека();
	КонецЕсли;

	Разделитель = "&";

	ШтрихкодМассивом = СтрРазделить(Штрихкод, Разделитель);

	Для Каждого ЧастьШтрихкода Из ШтрихкодМассивом Цикл

		Если СтрНачинаетсяС(ЧастьШтрихкода, "t=") Тогда
			Значение = СтрЗаменить(ЧастьШтрихкода, "t=", "");
			СтруктураЧека.t = Значение;
		ИначеЕсли СтрНачинаетсяС(ЧастьШтрихкода, "s=") Тогда
			Значение = СтрЗаменить(ЧастьШтрихкода, "s=", "");
			СтруктураЧека.s = Значение;
		ИначеЕсли СтрНачинаетсяС(ЧастьШтрихкода, "fn=") Тогда
			Значение = СтрЗаменить(ЧастьШтрихкода, "fn=", "");
			СтруктураЧека.fn = Значение;
		ИначеЕсли СтрНачинаетсяС(ЧастьШтрихкода, "i=") Тогда
			Значение = СтрЗаменить(ЧастьШтрихкода, "i=", "");
			СтруктураЧека.fd = Значение;
		ИначеЕсли СтрНачинаетсяС(ЧастьШтрихкода, "fd=") Тогда
			Значение = СтрЗаменить(ЧастьШтрихкода, "fd=", "");
			СтруктураЧека.fd = Значение;
		ИначеЕсли СтрНачинаетсяС(ЧастьШтрихкода, "fp=") Тогда
			Значение = СтрЗаменить(ЧастьШтрихкода, "fp=", "");
			СтруктураЧека.fp = Значение;
		ИначеЕсли СтрНачинаетсяС(ЧастьШтрихкода, "n=") Тогда
			Значение = СтрЗаменить(ЧастьШтрихкода, "n=", "");
			СтруктураЧека.n = Значение;
		Иначе
			Продолжить;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Функция СформироватьСтрокуТелаЗапросаПоДаннымЧека(СтруктураЧека)

	ТелоЗапроса = "";

	Для Каждого ЭлементСтруктуры Из СтруктураЧека Цикл

		Если ПустаяСтрока(ТелоЗапроса) Тогда
			Разделитель = "";
		Иначе
			Разделитель = "&";
		КонецЕсли;

		ТелоЗапроса = ТелоЗапроса + Разделитель + ЭлементСтруктуры.Ключ + "=" + ЭлементСтруктуры.Значение;

	КонецЦикла;

	Возврат ТелоЗапроса;

КонецФункции

#КонецОбласти

#Область JSON

Функция ПреобразоватьСтрокуВДату(Знач ДатаСтрокой)

	Дата = Дата(1, 1, 1);
	ТипДата = ОбщегоНазначенияКлиентСервер.ОписаниеТипаДата(ЧастиДаты.ДатаВремя);

	ЧастиДатыМассивом = СтрРазделить(ДатаСтрокой, "T");
	ДатаМассивом = СтрРазделить(ЧастиДатыМассивом[0], "-");

	Если ДатаМассивом.Количество() < 3 Тогда
		Возврат Дата;
	КонецЕсли;

	Год		 = ДатаМассивом[0];
	Месяц	 = ДатаМассивом[1];
	День	 = ДатаМассивом[2];

	Если ЧастиДатыМассивом.Количество() > 1 Тогда
		Время = ТипДата.ПривестиЗначение("01.01.0001 " + ЧастиДатыМассивом[1]);
	Иначе
		Время = Дата(1, 1, 1);
	КонецЕсли;

	Дата = Дата(Год, Месяц, День);
	Дата = Дата + (Время - Дата(1, 1, 1));

	Возврат Дата;

КонецФункции

Функция ПрочитатьДанныеJSON(Данные, ПрочитатьВСоответствие = Ложь) Экспорт

	Результат = Неопределено;

#Если ВебКлиент Тогда
	ВызватьИсключение "Метод недоступен на веб-клиенте";
#Иначе

		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Данные);
		Результат = ПрочитатьJSON(ЧтениеJSON, ПрочитатьВСоответствие);
		ЧтениеJSON.Закрыть();

#КонецЕсли

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти