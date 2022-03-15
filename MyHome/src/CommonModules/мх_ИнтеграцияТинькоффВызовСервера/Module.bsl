
#Область СлужебныйПрограммныйИнтерфейс

Процедура УстановитьЗначениеНастройкиВнешнейСистемы(Настройка, ИмяРеквизита, ЗначениеРеквизита, ОбновлятьЗначения = Истина) Экспорт
	
	мх_ИнтеграцияТинькофф.УстановитьЗначениеНастройкиВнешнейСистемы(Настройка, ИмяРеквизита, ЗначениеРеквизита); 
	
	Если ОбновлятьЗначения Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

Функция БазовыйАдресРесурсаАпи() Экспорт   
	
	Настройка = ПредопределенноеЗначение("Справочник.мх_ВнешниеСистемы.ЛичныйКабинетТинькофф");
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Настройка, "АдресРесурса");
	
КонецФункции    

Функция ПараметрыПодключенияКЛичномуКабинету(Настройка) Экспорт
	
	ТребуемыеПараметры = "Ссылка, Сервер, АдресРесурса, ЗащищенноеСоединение, Телефон, Пользователь, Пароль,
						|Тинькофф_wuid, Тинькофф_ИдентификаторСессии, Тинькофф_ИдентификаторПользователя";
	
	Возврат мх_ИнтеграцияСВнешнимиСистемамиПовтИсп.ДанныеВнешнейСистемы(Настройка, ТребуемыеПараметры, Истина);
	
КонецФункции

Функция КодироватьСтрокуДляURL(Данные) Экспорт
	
	Возврат КодироватьСтроку(Данные, СпособКодированияСтроки.КодировкаURL);
	
КонецФункции      

Функция РаскодироватьСтрокуДляURL(Данные) Экспорт
	
	Возврат РаскодироватьСтроку(Данные, СпособКодированияСтроки.КодировкаURL);
	
КонецФункции

#КонецОбласти