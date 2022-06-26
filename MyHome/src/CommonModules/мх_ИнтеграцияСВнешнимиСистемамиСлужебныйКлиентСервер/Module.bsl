#Если НЕ ВебКлиент Тогда
#Область СлужебныйПрограммныйИнтерфейс

// Отправляет данные через интернет.
//
// Параметры:
//  АдресСервера - Строка - URI;
//  Ресурс - Строка - ресурс, на который отправляются данные;
//  Заголовки - Соответствие - заголовки запроса;
//  Данные - ДвоичныеДанные - тело запроса;
//         - Строка - тело запроса строкой;
//         - Неопределено - отправить запрос без тела.
//  ПолучитьТелоКакСтроку - Булево - признак необходимости получения тела как строки;
//  Таймаут - Число - таймаут ожидания ответа сервера;
//  НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - текущая настройка обмена с банком.
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус - Булево - результат получения файла.
//      * Тело - ДвоичныеДанные, Строка, Неопределено - данные ответа сервера.
//      * СообщениеОбОшибке - Строка, Неопределено - сообщение об ошибке, если статус Ложь.
//      * КодСостояния - Число, Неопределено - код состояния HTTP-ответа. Наличие кода означает, что был ответ от сервера.
//
Функция ОтправитьЗапрос(
	АдресСервера,
	Ресурс,
	Заголовки,
	Данные,
	ПолучитьТелоКакСтроку = Ложь,
	Метод = "POST",
	ВнешняяСистема = Неопределено) Экспорт

	Перенаправления = Новый Массив;
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("АдресСервера", АдресСервера);
	ПараметрыОтправки.Вставить("Ресурс", Ресурс);
	ПараметрыОтправки.Вставить("Заголовки", Заголовки);
	ПараметрыОтправки.Вставить("Данные", Данные);

	Возврат ОтправитьЗапросРекурсивно(
		ПараметрыОтправки, ПолучитьТелоКакСтроку, Перенаправления, Метод, ВнешняяСистема)
		
КонецФункции 		

Функция ОтправитьЗапросРекурсивно(
	ПараметрыОтправки,
	ПолучитьТелоКакСтроку,
	Перенаправления,
	Метод = "POST",
	ВнешняяСистема = Неопределено)
	
	СтруктураВозврата = Новый Структура("Статус, Тело, СообщениеОбОшибке, КодСостояния, Заголовки");

	Соединение = СоединениеССервером(ПараметрыОтправки.АдресСервера, 0);

	HTTPЗапрос = Новый HTTPЗапрос(ПараметрыОтправки.Ресурс, ПараметрыОтправки.Заголовки);

	Если ТипЗнч(ПараметрыОтправки.Данные) = Тип("ДвоичныеДанные") Тогда
		HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(ПараметрыОтправки.Данные);
	ИначеЕсли ТипЗнч(ПараметрыОтправки.Данные) = Тип("Строка") Тогда
		HTTPЗапрос.УстановитьТелоИзСтроки(ПараметрыОтправки.Данные);
	КонецЕсли;

	Попытка    
		Если Метод = "POST" Тогда
			ОтветHTTP = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
		Иначе
			ОтветHTTP = Соединение.Получить(HTTPЗапрос);
		КонецЕсли;
	Исключение
		СтруктураВозврата.Статус = Ложь;
		СтруктураВозврата.СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат СтруктураВозврата;
	КонецПопытки;

	Если ОтветHTTP.КодСостояния = 301 // 301 Moved Permanently
		Или ОтветHTTP.КодСостояния = 302 // 302 Found, 302 Moved Temporarily
		Или ОтветHTTP.КодСостояния = 303 // 303 See Other by GET
		Или ОтветHTTP.КодСостояния = 307 // 307 Temporary Redirect
		Или ОтветHTTP.КодСостояния = 308 Тогда // 308 Permanent Redirect
		Если Перенаправления.Количество() > 7 Тогда
			СтруктураВозврата.Статус = Ложь;
			СтруктураВозврата.СообщениеОбОшибке = НСтр("ru = 'Превышено количество перенаправлений.'");
			Возврат СтруктураВозврата;
		Иначе

			НовыйURL = ОтветHTTP.Заголовки["Location"];

			Если НовыйURL = Неопределено Тогда
				СтруктураВозврата.Статус = Ложь;
				СтруктураВозврата.СообщениеОбОшибке = НСтр("ru = 'Некорректное перенаправление, отсутствует HTTP-заголовок ответа ""Location"".'");
				Возврат СтруктураВозврата;
			КонецЕсли;

			НовыйURL = СокрЛП(НовыйURL);

			Если ПустаяСтрока(НовыйURL) Тогда
				СтруктураВозврата.Статус = Ложь;
				СтруктураВозврата.СообщениеОбОшибке = НСтр("ru = 'Некорректное перенаправление, пустой HTTP-заголовок ответа ""Location"".'");
				Возврат СтруктураВозврата;
			КонецЕсли;

			Если Перенаправления.Найти(НовыйURL) <> Неопределено Тогда
				СтруктураВозврата.Статус = Ложь;
				СтруктураВозврата.СообщениеОбОшибке = СтрШаблон(НСтр("ru = 'Циклическое перенаправление.
					|Попытка перейти на %1 уже выполнялась ранее.'"), НовыйURL);
				Возврат СтруктураВозврата;
			КонецЕсли;

			Перенаправления.Добавить(ПараметрыОтправки.АдресСервера);

			Возврат ОтправитьЗапросРекурсивно(
				ПараметрыОтправки, ПолучитьТелоКакСтроку, Перенаправления, Метод, ВнешняяСистема);

		КонецЕсли;

	КонецЕсли;

	HTTPЗапрос = Неопределено;

	Если ОтветHTTP.КодСостояния = 200 Тогда
		СтруктураВозврата.Статус = Истина;
		Если ПолучитьТелоКакСтроку Тогда
			СтруктураВозврата.Тело = ОтветHTTP.ПолучитьТелоКакСтроку();
		Иначе
			СтруктураВозврата.Тело = ОтветHTTP.ПолучитьТелоКакДвоичныеДанные();
		КонецЕсли;
	Иначе
		СтруктураВозврата.Статус = Ложь;
		СтруктураВозврата.СообщениеОбОшибке = РасшифровкаКодаСостоянияHTTP(ОтветHTTP.КодСостояния);
		СтруктураВозврата.Тело = ОтветHTTP.ПолучитьТелоКакСтроку();
	КонецЕсли;

	СтруктураВозврата.КодСостояния = ОтветHTTP.КодСостояния;
	СтруктураВозврата.Заголовки = ОтветHTTP.Заголовки;
	СтруктураВозврата.Вставить("ВнешняяСистема", ВнешняяСистема);
	
	ЗаписатьВЖурналСообщенийИнтеграции(ПараметрыОтправки, СтруктураВозврата);	

	Возврат СтруктураВозврата;

КонецФункции  

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьВЖурналСообщенийИнтеграции(ПараметрыОтправки, СтруктураВозврата)
	
	#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
	мх_ИнтеграцияСВнешнимиСистемамиВызовСервера.ЗаписатьВЖурналСообщенийИнтеграции(ПараметрыОтправки, СтруктураВозврата);
	#КонецЕсли
	
	#Если ТонкийКлиент или ВебКлиент Тогда
	мх_ИнтеграцияСВнешнимиСистемамиКлиент.ЗаписатьВЖурналСообщенийИнтеграции(ПараметрыОтправки, СтруктураВозврата);		
	#КонецЕсли	
	
КонецПроцедуры

#КонецОбласти

#Область HTTP

// Определяет параметры HTTP соединения по URL адресу.
//
// Параметры:
//  АдресСайта - Строка - URL сайта;
//  ЗащищенноеСоединение - Булево - возвращает Истина, если требуется шифрование;
//  Адрес - Строка - адрес сайта без протокола;
//  Протокол - Строка - название протокола.
//
Процедура ОпределитьПараметрыСайта(Знач АдресСайта, ЗащищенноеСоединение, Адрес, Протокол) Экспорт
	
	АдресСайта = СокрЛП(АдресСайта);
	
	АдресСайта = СтрЗаменить(АдресСайта, "\", "/");
	АдресСайта = СтрЗаменить(АдресСайта, " ", "");
	
	Если НРег(Лев(АдресСайта, 7)) = "http://" Тогда
		Протокол = "http";
		Адрес = Сред(АдресСайта,8);
		ЗащищенноеСоединение = Неопределено;
	ИначеЕсли НРег(Лев(АдресСайта, 8)) = "https://" Тогда
		Протокол =  "https";
		Адрес = Сред(АдресСайта,9);
		
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	КонецЕсли;
	
КонецПроцедуры

 // Возвращает текст расшифровки кода состояния HTTP
//
// Параметры:
//  КодСостояния - Число - код состояния HTTP
// 
// Возвращаемое значение:
//  Строка - подробное описание кода.
//
Функция РасшифровкаКодаСостоянияHTTP(КодСостояния) Экспорт
	
	Если КодСостояния = 304 Тогда // Not Modified
		Расшифровка = НСтр("ru = 'Нет необходимости повторно передавать запрошенные ресурсы.'");
	ИначеЕсли КодСостояния = 400 Тогда // Bad Request
		Расшифровка = НСтр("ru = 'Запрос не может быть исполнен.'");
	ИначеЕсли КодСостояния = 401 Тогда // Unauthorized
		Расшифровка = НСтр("ru = 'Попытка авторизации на сервере была отклонена.'");
	ИначеЕсли КодСостояния = 402 Тогда // Payment Required
		Расшифровка = НСтр("ru = 'Требуется оплата.'");
	ИначеЕсли КодСостояния = 403 Тогда // Forbidden
		Расшифровка = НСтр("ru = 'К запрашиваемому ресурсу нет доступа.'");
	ИначеЕсли КодСостояния = 404 Тогда // Not Found
		Расшифровка = НСтр("ru = 'Запрашиваемый ресурс не найден на сервере.'");
	ИначеЕсли КодСостояния = 405 Тогда // Method Not Allowed
		Расшифровка = НСтр("ru = 'Метод запроса не поддерживается сервером.'");
	ИначеЕсли КодСостояния = 406 Тогда // Not Acceptable
		Расшифровка = НСтр("ru = 'Запрошенный формат данных не поддерживается сервером.'");
	ИначеЕсли КодСостояния = 407 Тогда // Proxy Authentication Required
		Расшифровка = НСтр("ru = 'Ошибка аутентификации на прокси-сервере'");
	ИначеЕсли КодСостояния = 408 Тогда // Request Timeout
		Расшифровка = НСтр("ru = 'Время ожидания сервером передачи от клиента истекло.'");
	ИначеЕсли КодСостояния = 409 Тогда // Conflict
		Расшифровка = НСтр("ru = 'Запрос не может быть выполнен из-за конфликтного обращения к ресурсу.'");
	ИначеЕсли КодСостояния = 410 Тогда // Gone
		Расшифровка = НСтр("ru = 'Ресурс на сервере был перемешен.'");
	ИначеЕсли КодСостояния = 411 Тогда // Length Required
		Расшифровка = НСтр("ru = 'Сервер требует указание ""Content-length."" в заголовке запроса.'");
	ИначеЕсли КодСостояния = 412 Тогда // Precondition Failed
		Расшифровка = НСтр("ru = 'Запрос не применим к ресурсу'");
	ИначеЕсли КодСостояния = 413 Тогда // Request Entity Too Large
		Расшифровка = НСтр("ru = 'Сервер отказывается обработать, слишком большой объем передаваемых данных.'");
	ИначеЕсли КодСостояния = 414 Тогда // Request-URL Too Long
		Расшифровка = НСтр("ru = 'Сервер отказывается обработать, слишком длинный URL.'");
	ИначеЕсли КодСостояния = 415 Тогда // Unsupported Media-Type
		Расшифровка = НСтр("ru = 'Сервер заметил, что часть запроса была сделана в неподдерживаемом формат'");
	ИначеЕсли КодСостояния = 416 Тогда // Requested Range Not Satisfiable
		Расшифровка = НСтр("ru = 'Часть запрашиваемого ресурса не может быть предоставлена'");
	ИначеЕсли КодСостояния = 417 Тогда // Expectation Failed
		Расшифровка = НСтр("ru = 'Сервер не может предоставить ответ на указанный запрос.'");
	ИначеЕсли КодСостояния = 429 Тогда // Too Many Requests
		Расшифровка = НСтр("ru = 'Слишком много запросов за короткое время.'");
	ИначеЕсли КодСостояния = 500 Тогда // Internal Server Error
		Расшифровка = НСтр("ru = 'Внутренняя ошибка сервера.'");
	ИначеЕсли КодСостояния = 501 Тогда // Not Implemented
		Расшифровка = НСтр("ru = 'Сервер не поддерживает метод запроса.'");
	ИначеЕсли КодСостояния = 502 Тогда // Bad Gateway
		Расшифровка = НСтр("ru = 'Сервер, выступая в роли шлюза или прокси-сервера, 
		                         |получил недействительное ответное сообщение от вышестоящего сервера.'");
	ИначеЕсли КодСостояния = 503 Тогда // Server Unavailable
		Расшифровка = НСтр("ru = 'Сервер временно не доступен.'");
	ИначеЕсли КодСостояния = 504 Тогда // Gateway Timeout
		Расшифровка = НСтр("ru = 'Сервер в роли шлюза или прокси-сервера 
		                         |не дождался ответа от вышестоящего сервера для завершения текущего запроса.'");
	ИначеЕсли КодСостояния = 505 Тогда // HTTP Version Not Supported
		Расшифровка = НСтр("ru = 'Сервер не поддерживает указанную в запросе версию протокола HTTP'");
	ИначеЕсли КодСостояния = 506 Тогда // Variant Also Negotiates
		Расшифровка = НСтр("ru = 'Сервер настроен некорректно, и не способен обработать запрос.'");
	ИначеЕсли КодСостояния = 507 Тогда // Insufficient Storage
		Расшифровка = НСтр("ru = 'На сервере недостаточно места для выполнения запроса.'");
	ИначеЕсли КодСостояния = 509 Тогда // Bandwidth Limit Exceeded
		Расшифровка = НСтр("ru = 'Сервер превысил отведенное ограничение на потребление трафика.'");
	ИначеЕсли КодСостояния = 510 Тогда // Not Extended
		Расшифровка = НСтр("ru = 'Сервер требует больше информации о совершаемом запросе.'");
	ИначеЕсли КодСостояния = 511 Тогда // Network Authentication Required
		Расшифровка = НСтр("ru = 'Требуется авторизация на сервере.'");
	Иначе 
		Расшифровка = НСтр("ru = '<Неизвестный код состояния>.'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '[%1] %2'"), 
		КодСостояния, 
		Расшифровка);
	
КонецФункции
  
// Функция формирует прокси по настройкам прокси и протоколу.
//
// Параметры:
//  Протокол - Строка - протокол для которого устанавливаются параметры прокси сервера, например http, https, ftp.
//
// Возвращаемое значение:
//  ИнтернетПрокси - описание параметров прокси-серверов.
// 
Функция СформироватьПрокси(Протокол) Экспорт
	
	// НастройкаПроксиСервера - Соответствие:
	//  ИспользоватьПрокси - использовать ли прокси-сервер;
	//  НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов;
	//  ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера;
	//  Сервер       - адрес прокси-сервера;
	//  Порт         - порт прокси-сервера;
	//  Пользователь - имя пользователя для авторизации на прокси-сервере;
	//  Пароль       - пароль пользователя.
	
	
	//НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	//Если НастройкаПроксиСервера <> Неопределено Тогда
	//	ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
	//	ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
	//	Если ИспользоватьПрокси Тогда
	//		Если ИспользоватьСистемныеНастройки Тогда
	//			// Системные настройки прокси-сервера.
	//			Прокси = Новый ИнтернетПрокси(Истина);
	//		Иначе
	//			// Ручные настройки прокси-сервера.
	//			Прокси = Новый ИнтернетПрокси;
	//			Прокси.Установить(Протокол, НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"],
	//				НастройкаПроксиСервера["Пользователь"], НастройкаПроксиСервера["Пароль"]);
	//			Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
	//		КонецЕсли;
	//	Иначе
	//		// Не использовать прокси-сервер.
	//		Прокси = Новый ИнтернетПрокси(Ложь);
	//	КонецЕсли;
	//Иначе
	//	Прокси = Неопределено;
	//КонецЕсли;
	//
	//Возврат Прокси;
	
КонецФункции

// Создает соединение с сервером в интернет.
//
// Параметры:
//  АдресСервера - Строка - URI
//  Таймаут - Число - Определяет время ожидания осуществляемого соединения и операций, в секундах. 0 - таймаут не установлен.
// 
// Возвращаемое значение:
// HTTPСоединение - предназначен для работы с файлами на http-серверах.
//
Функция СоединениеССервером(АдресСервера, Таймаут) Экспорт

	Перем ЗащищенноеСоединение;
	Адрес = "";
	Протокол = "";

	ОпределитьПараметрыСайта(АдресСервера, ЗащищенноеСоединение, Адрес, Протокол);
	//Прокси = СформироватьПрокси(Протокол);

	//Соединение = Новый HTTPСоединение(Адрес, , , , Прокси, Таймаут, ЗащищенноеСоединение);
	Соединение = Новый HTTPСоединение(Адрес, , , , , Таймаут, ЗащищенноеСоединение);

	Возврат Соединение;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли