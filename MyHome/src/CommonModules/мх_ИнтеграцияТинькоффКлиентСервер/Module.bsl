
#Область ПрограммныйИнтерфейс

#Область Авторизация
 
Функция ВыполнитьВходВЛичныйКабинет(Настройка) Экспорт
	
	Результат = Новый Структура("Успех, ОписаниеОшибки", Истина, "");
	
	ПараметрыПодключения = мх_ИнтеграцияТинькоффВызовСервера.ПараметрыПодключенияКЛичномуКабинету(Настройка);
	Заголовки = мх_ИнтеграцияТинькоффКлиентСервер.ЗаголовкиПриВыполненииВхода(ПараметрыПодключения);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("sessionid", ПараметрыПодключения.Тинькофф_ИдентификаторСессии);
	
	РезультатЗапроса = мх_ИнтеграцияТинькоффКлиентСервер.ОтправитьЗапросАпи("session_status",
																			ПараметрыЗапроса,
																			ПараметрыПодключения.Сервер,
																			Заголовки,
																			,
																			"GET",
																			Настройка);
																			
	Если РезультатЗапроса.Статус <> Истина Тогда  
		Возврат мх_ИнтеграцияСВнешнимиСистемамиКлиентСервер.РезультатСОшибкой(РезультатЗапроса.СообщениеОбОшибке, Результат);																			
	КонецЕсли;	
		
	ОбработатьРезультатЗапросаПриВыполненииВхода(РезультатЗапроса, Результат, ПараметрыПодключения, Заголовки);
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти

Функция ПараметрыПодключенияКЛичномуКабинету(Настройка) Экспорт
	
	Возврат мх_ИнтеграцияТинькоффВызовСервера.ПараметрыПодключенияКЛичномуКабинету(Настройка);	
	
КонецФункции

Функция СформироватьСтрокуЗапросаАпиПоШаблону(Метод, Знач БазовыйАдрес = "", Знач Постфикс = "", Знач Параметры = Неопределено) Экспорт
	
	Если ПустаяСтрока(БазовыйАдрес) Тогда
		БазовыйАдрес = мх_ИнтеграцияТинькоффКлиентСерверПовтИсп.БазовыйАдресРесурсаАпи();
	КонецЕсли;
	
	Если ПустаяСтрока(Постфикс) Тогда
		Постфикс = мх_ИнтеграцияТинькоффКлиентСерверПовтИсп.ПостфиксБазовогоАдресаРесурсаАпи();
	КонецЕсли;
	
	ШаблонЗапроса = "%1/%2?%3";
	
	СтрокаЗапроса = СтрШаблон(ШаблонЗапроса, БазовыйАдрес, Метод, Постфикс);
	
	Если Параметры <> Неопределено Тогда
		ДобавитьПараметрыКСтрокеЗапроса(СтрокаЗапроса, Параметры);
	КонецЕсли;
	
	Возврат СтрокаЗапроса;
	
КонецФункции 

Функция СформироватьСтрокуПараметров(Параметры) Экспорт
	
	ШаблонПараметра = "%1=%2";
	
	МассивПараметров = Новый Массив;
	
	Для каждого Параметр из Параметры Цикл
		
		МассивПараметров.Добавить(СтрШаблон(ШаблонПараметра, Параметр.Ключ, Параметр.Значение));
		
	КонецЦикла;                                                                
	
	СтрокаПараметров = СтрСоединить(МассивПараметров, "&");
	
	Возврат СтрокаПараметров;
	
КонецФункции

Функция JSONВЗначение(Строка, ИменаСвойствСоЗначениямиДата = Неопределено) Экспорт
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(Строка);
	
	Возврат ПрочитатьJSON(Чтение, Истина, ИменаСвойствСоЗначениямиДата);
	
КонецФункции

Процедура ДобавитьПараметрыКСтрокеЗапроса(Ресурс, Параметры) Экспорт
	
	СтрокаПараметров = СформироватьСтрокуПараметров(Параметры);
	
	Ресурс = Ресурс + ?(ПустаяСтрока(Ресурс), "", "&") + СтрокаПараметров;
	
КонецПроцедуры

Функция НовыйУникальныйИдентификатор() Экспорт
	
	Уид = Новый УникальныйИдентификатор;
	
	Уид = СтрЗаменить(НРег(Строка(Уид)),"-","");
	
	Возврат Уид;
	
КонецФункции

Функция ДатаВФорматеTimestamp(Знач Дата, Постфикс = "") Экспорт
	
	ДатаВФормате = Формат(Дата - дата(1970,1,1,1,0,0), "ЧГ=0");
	
	ДатаВФормате = ДатаВФормате + Постфикс;
	
	Возврат ДатаВФормате;
		
КонецФункции

Функция ОбязательныеЗаголовкиЗапроса() Экспорт
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-type","application/x-www-form-urlencoded");
	Заголовки.Вставить("Connection","keep-alive");
	
	Возврат Заголовки;
	
КонецФункции

Функция ЗаголовкиПриВыполненииВхода(Знач ПараметрыПодключения) Экспорт
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-type","application/x-www-form-urlencoded");
	Заголовки.Вставить("Connection","keep-alive");
	Заголовки.Вставить("Accept-Encoding", "gzip, deflate, br"); 
	Заголовки.Вставить("Accept-Language", "ru,en;q=0.9,en-GB;q=0.8,en-US;q=0.7");
	
	Куки = Новый Массив();
	ШаблонКуки = "%1=%2";
	wuid = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПодключения, "Тинькофф_wuid", "");
	Куки.Добавить(СтрШаблон(ШаблонКуки, "__P__wuid", wuid));
	Куки.Добавить(СтрШаблон(ШаблонКуки, "userType", "Visitor"));  	
	Заголовки.Вставить("Cookie", СтрСоединить(Куки, "; ")); 
	
	Возврат Заголовки;	
	
КонецФункции

Функция ТелоЗапросаПриАвторизацииПослеВводаТелефона(Знач ПараметрыПодключения) Экспорт
	
	Телефон = мх_ИнтеграцияТинькоффВызовСервера.КодироватьСтрокуДляURL(ПараметрыПодключения.Телефон);
	
	ПараметрыТела = Новый Структура;
	ПараметрыТела.Вставить("device_type", "desktop");
	ПараметрыТела.Вставить("form_view_mode", "desktop");               
	ПараметрыТела.Вставить("phone", Телефон);  
	
	ТелоЗапроса = мх_ИнтеграцияТинькоффКлиентСервер.СформироватьСтрокуПараметров(ПараметрыТела);
	
	Возврат ТелоЗапроса;	
	
КонецФункции

Функция ОтправитьЗапросАпи(
			ИдентификаторЗапроса,
			ПараметрыЗапроса = Неопределено,
			АдресСервера,
			Заголовки,
			ТелоЗапроса,
			Метод = "POST",
			ВнешняяСистема = Неопределено) Экспорт
			
	АдресРесурса = мх_ИнтеграцияТинькоффКлиентСервер.СформироватьСтрокуЗапросаАпиПоШаблону(ИдентификаторЗапроса,,,ПараметрыЗапроса);
	
	Результат = мх_ИнтеграцияСВнешнимиСистемамиСлужебныйКлиентСервер.ОтправитьЗапрос(АдресСервера,
																					АдресРесурса,
																					Заголовки,
																					ТелоЗапроса,
																					Истина,
																					Метод,
																					ВнешняяСистема);
																					
	Результат.Вставить("ДанныеОтвета", Неопределено);
	
	Если Результат.Статус = Истина Тогда
		Результат.ДанныеОтвета = мх_ИнтеграцияТинькоффКлиентСервер.JSONВЗначение(Результат.Тело);	
	КонецЕсли;			
	
	Возврат Результат;
			
КонецФункции

Функция ПолучитьДанныеПлатежей(Параметры) Экспорт
	
	Результат = Новый Структура("Успех, ОписаниеОшибки, ДанныеПлатежей", Истина, "", Неопределено); 
	
	ИменаПараметров = "ВнешняяСистема, ДатаНачала, ДатаОкончания";
		
	ПроверкаПараметров = мх_ИнтеграцияСВнешнимиСистемамиКлиентСервер.ПроверитьЗаполнениеПараметров(Параметры, ИменаПараметров);
	
	Если НЕ ПроверкаПараметров.Успех Тогда
		Возврат мх_ИнтеграцияСВнешнимиСистемамиКлиентСервер.РезультатСОшибкой(ПроверкаПараметров.ОписаниеОшибки, Результат);
	КонецЕсли;
	
	ВнешняяСистема = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ВнешняяСистема", Неопределено);
	
	ПараметрыПодключения = ПараметрыПодключенияКЛичномуКабинету(ВнешняяСистема);
	Заголовки = ОбязательныеЗаголовкиЗапроса(); 
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("account", ПараметрыПодключения.Тинькофф_ИдентификаторПользователя);
	ПараметрыЗапроса.Вставить("end", ДатаВФорматеTimestamp(Параметры.ДатаОкончания, "999"));
	ПараметрыЗапроса.Вставить("start", ДатаВФорматеTimestamp(Параметры.ДатаНачала, "000"));
	ПараметрыЗапроса.Вставить("sessionid", ПараметрыПодключения.Тинькофф_ИдентификаторСессии);
	ПараметрыЗапроса.Вставить("wuid", ПараметрыПодключения.Тинькофф_wuid);
	
	РезультатЗапроса = мх_ИнтеграцияТинькоффКлиентСервер.ОтправитьЗапросАпи("operations",
																			ПараметрыЗапроса,
																			ПараметрыПодключения.Сервер,
																			Заголовки,
																			Неопределено,
																			"GET",
																			ВнешняяСистема); 
																			
	Если РезультатЗапроса.Статус <> Истина Тогда
		Возврат мх_ИнтеграцияСВнешнимиСистемамиКлиентСервер.РезультатСОшибкой(РезультатЗапроса.СообщениеОбОшибке, Результат);																			
	КонецЕсли;
																																							
	ДанныеОтвета = РезультатЗапроса.ДанныеОтвета;
	
	КодРезультата = ДанныеОтвета["resultCode"];
	
	Если КодРезультата <> "OK" Тогда
		Возврат мх_ИнтеграцияСВнешнимиСистемамиКлиентСервер.РезультатСОшибкой(РезультатЗапроса.Тело, Результат);
	КонецЕсли;                                                                                              
	
	Результат.ДанныеПлатежей = ДанныеОтвета["payload"];	
	
	Возврат Результат;
	
КонецФункции

Функция СтатусСессии(ВнешняяСистема) Экспорт  
	
	Результат = Новый Структура("Успех, ОписаниеОшибки, accessLevel, millisLeft, userId", Истина, "");
	
	ПараметрыПодключения = ПараметрыПодключенияКЛичномуКабинету(ВнешняяСистема);
	Заголовки = ОбязательныеЗаголовкиЗапроса();
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("sessionid", ПараметрыПодключения.Тинькофф_ИдентификаторСессии);
	
	РезультатЗапроса = мх_ИнтеграцияТинькоффКлиентСервер.ОтправитьЗапросАпи("session_status",
																			ПараметрыЗапроса,
																			ПараметрыПодключения.Сервер,
																			Заголовки,
																			Неопределено,
																			"GET",
																			ВнешняяСистема); 
																			
	Если РезультатЗапроса.Статус <> Истина Тогда
		Возврат мх_ИнтеграцияСВнешнимиСистемамиКлиентСервер.РезультатСОшибкой(РезультатЗапроса.СообщениеОбОшибке, Результат);  																			
	КонецЕсли;																			
																			
	ДанныеОтвета = РезультатЗапроса.ДанныеОтвета;
	
	КодРезультата = ДанныеОтвета["resultCode"];
	
	Если КодРезультата <> "OK" Тогда	
		Возврат Результат;	
	КонецЕсли;                                                                                                  
	
	ИнформацияОСессии = ДанныеОтвета["payload"];
	
	Результат.Вставить("accessLevel", ИнформацияОСессии["accessLevel"]);
	Результат.Вставить("millisLeft", ИнформацияОСессии["millisLeft"]);
	Результат.Вставить("userId", ИнформацияОСессии["userId"]);
																			
	Возврат Результат;																
	
КонецФункции

#КонецОбласти   

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьРезультатЗапросаПриВыполненииВхода(Знач РезультатЗапроса, Результат, ПараметрыПодключения, Заголовки)
	
	ДанныеОтвета = РезультатЗапроса.ДанныеОтвета;
	КодОтвета = ДанныеОтвета["resultCode"];
	
	Если КодОтвета = "SESSION_IS_ABSENT" Тогда
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("sessionid", ПараметрыПодключения.Тинькофф_ИдентификаторСессии);
		ПараметрыЗапроса.Вставить("wuid", ПараметрыПодключения.Тинькофф_wuid);
		
		РезультатЗапроса = мх_ИнтеграцияТинькоффКлиентСервер.ОтправитьЗапросАпи("session",
																			ПараметрыЗапроса,
																			ПараметрыПодключения.Сервер,
																			Заголовки,
																			,
																			"GET",
																			ПараметрыПодключения.Ссылка);
																			
		sessionid = РезультатЗапроса.ДанныеОтвета["payload"];
		мх_ИнтеграцияТинькоффВызовСервера.УстановитьЗначениеНастройкиВнешнейСистемы(ПараметрыПодключения.Ссылка,
																					 "Тинькофф_ИдентификаторСессии",
																					 sessionid);    
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("sessionid", sessionid); 
		
		РезультатЗапроса = мх_ИнтеграцияТинькоффКлиентСервер.ОтправитьЗапросАпи("session_status",
																			ПараметрыЗапроса,
																			ПараметрыПодключения.Сервер,
																			Заголовки,
																			,
																			"GET",
																			ПараметрыПодключения.Ссылка);
																			
													
		Если РезультатЗапроса.Статус <> Истина Тогда
			Результат.Успех = Ложь;
			Результат.ОписаниеОшибки = РезультатЗапроса.СообщениеОбОшибке;
			Возврат;
		КонецЕсли;	
	
		ДанныеОтвета = РезультатЗапроса.ДанныеОтвета;
		КодОтвета = ДанныеОтвета["resultCode"];
		
		ОбработатьРезультатЗапросаПриВыполненииВхода(РезультатЗапроса, Результат, ПараметрыПодключения, Заголовки); 
		
	ИначеЕсли КодОтвета = "OK" Тогда
		   	
		ИнформацияОСессии = ДанныеОтвета["payload"];
		
		УровеньДоступа = ИнформацияОСессии["accessLevel"];
		
		Если УровеньДоступа = "ANONYMOUS" Тогда
			
			ПараметрыЗапроса = Новый Структура;
			ПараметрыЗапроса.Вставить("sessionid", ПараметрыПодключения.Тинькофф_ИдентификаторСессии);
			ПараметрыЗапроса.Вставить("wuid", ПараметрыПодключения.Тинькофф_wuid);
			
			ТелоЗапроса = мх_ИнтеграцияТинькоффКлиентСерверПовтИсп.ТелоЗапросаАвторизацииПослеВводаПароля(ПараметрыЗапроса.wuid,
																										 ПараметрыПодключения.Пароль);	
																										 
			РезультатЗапроса = мх_ИнтеграцияТинькоффКлиентСервер.ОтправитьЗапросАпи("sign_up",
																			ПараметрыЗапроса,
																			ПараметрыПодключения.Сервер,
																			Заголовки,
																			ТелоЗапроса,,
																			ПараметрыПодключения.Ссылка);
																			
			ОбработатьРезультатЗапросаПриВыполненииВхода(РезультатЗапроса, Результат, ПараметрыПодключения, Заголовки);
			
		ИначеЕсли УровеньДоступа = "CANDIDATE" Тогда
		
			ПараметрыЗапроса = Новый Структура;
			ПараметрыЗапроса.Вставить("sessionid", ПараметрыПодключения.Тинькофф_ИдентификаторСессии);
			ПараметрыЗапроса.Вставить("wuid", ПараметрыПодключения.Тинькофф_wuid);
			
			ТелоЗапроса = мх_ИнтеграцияТинькоффКлиентСерверПовтИсп.ТелоЗапросаАвторизацииПослеВводаПароля(ПараметрыЗапроса.wuid,
																										 ПараметрыПодключения.Пароль);	
																										 
			РезультатЗапроса = мх_ИнтеграцияТинькоффКлиентСервер.ОтправитьЗапросАпи("level_up",
																			ПараметрыЗапроса,
																			ПараметрыПодключения.Сервер,
																			Заголовки,
																			ТелоЗапроса,,
																			ПараметрыПодключения.Ссылка);
																			
			ОбработатьРезультатЗапросаПриВыполненииВхода(РезультатЗапроса, Результат, ПараметрыПодключения, Заголовки);
			
		ИначеЕсли УровеньДоступа = "CLIENT" Тогда
					
			Возврат;
			
		КонецЕсли;			
		
	Иначе
		
		Результат.Успех = Ложь;
		Результат.ОписаниеОшибки = СтрШаблон(НСтр("ru = 'Необрабатываемый код ответа %1'"), КодОтвета);
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти