
#Область ПрограммныйИнтерфейс

Функция ПараметрыПодключенияКЛичномуКабинету(Настройка) Экспорт
	
	мх_ИнтеграцияТинькоффВызовСервера.ПараметрыПодключенияКЛичномуКабинету(Настройка);	
	
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
			Метод = "POST") Экспорт
			
	АдресРесурса = мх_ИнтеграцияТинькоффКлиентСервер.СформироватьСтрокуЗапросаАпиПоШаблону(ИдентификаторЗапроса,,,ПараметрыЗапроса);
	
	Результат = мх_ИнтеграцияСВнешнимиСистемамиСлужебныйКлиентСервер.ОтправитьЗапрос(АдресСервера,
																					АдресРесурса,
																					Заголовки,
																					ТелоЗапроса,
																					Истина);
																					
	Результат.Вставить("ДанныеОтвета", Неопределено);
	
	Если Результат.Статус = Истина Тогда
		Результат.ДанныеОтвета = мх_ИнтеграцияТинькоффКлиентСервер.JSONВЗначение(Результат.Тело);	
	КонецЕсли;			
	
	Возврат Результат;
			
КонецФункции

#КонецОбласти