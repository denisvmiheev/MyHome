#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаписатьВЖурналСообщенийИнтеграции(ПараметрыОтправки, СтруктураВозврата) Экспорт
	
	ПараметрыЖурнала = Новый Структура;
	ПараметрыЖурнала.Вставить("АдресСервера", ПараметрыОтправки.АдресСервера);
	ПараметрыЖурнала.Вставить("АдресРесурса", ПараметрыОтправки.Ресурс);
	ПараметрыЖурнала.Вставить("ТелоЗапроса", ПараметрыОтправки.Данные);
	ПараметрыЖурнала.Вставить("ТелоОтвета", СтруктураВозврата.Тело);
	ПараметрыЖурнала.Вставить("КодОтвета", СтруктураВозврата.КодСостояния);
	
	РегистрыСведений.мх_ЖурналСообщенийИнтеграции.ДобавитьЗаписьЖурналаРегистрации(ПараметрыЖурнала);	
	
КонецПроцедуры

#КонецОбласти