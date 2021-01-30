
#Область ПрограммныйИнтерфейс

// Возвращает данные внешней системы для проверки чеков
// Если система не указана в настройках, то генерируется исключение
// 
// Возвращаемое значение:
// 	Структура - см. возвращаемое значение процедуры "ДанныеВнешнейСистемы"
Функция ДанныеСистемыПроверкиЧеков() Экспорт
	
	Система = ИспользуемаяСистемаПроверкиЧеков();
	
	Если Не ЗначениеЗаполнено(Система) Тогда
		ТекстИсключения = НСтр("ru = 'В настройках программы не указана используемая система для проверки чеков'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	 
	ДанныеСистемы = ДанныеВнешнейСистемы(Система);
	
	Возврат ДанныеСистемы;
	
КонецФункции

// Возвращает данные внешней системы
// 
// Параметры:
// 	ВнешняяСистема - СправочникСсылка.ВнешниеСистемы - Внешняя система
// 	ПодставлятьНеопределено - Булево - Если Истина, то каждое 
// 	незаполненное значение будет заменено на "Неопределено"
// Возвращаемое значение:
// 	Структура - данные внешней системы
Функция ДанныеВнешнейСистемы(ВнешняяСистема, ПодставлятьНеопределено = Истина) Экспорт
	
	СтрокаРеквизитов = "Сервер,Порт,АдресРесурса,ТокенДоступа,Пользователь,Пароль,ЗащищенноеСоединение";
	
	ДанныеВнешнейСистемы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВнешняяСистема, СтрокаРеквизитов);
	
	Если ПодставлятьНеопределено Тогда
		
		Для каждого КлючИЗначение из ДанныеВнешнейСистемы Цикл
			Если НЕ ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
				ДанныеВнешнейСистемы[КлючИЗначение.Ключ] = Неопределено;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ДанныеВнешнейСистемы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИспользуемаяСистемаПроверкиЧеков()
	
	УстановитьПривилегированныйРежим(Истина);
	Система = Константы.СистемаПроверкиЧеков.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Система;
	
КонецФункции

#КонецОбласти