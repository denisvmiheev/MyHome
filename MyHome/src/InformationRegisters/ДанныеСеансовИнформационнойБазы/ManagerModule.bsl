#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Процедура ЗаписатьДанныеСеанса(ДанныеСеанса) Экспорт
	
	Менеджер = РегистрыСведений.ДанныеСеансовИнформационнойБазы.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Менеджер, ДанныеСеанса);
	Менеджер.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
