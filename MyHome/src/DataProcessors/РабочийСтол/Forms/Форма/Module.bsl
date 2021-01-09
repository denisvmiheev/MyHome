#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодОтчета = Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотМесяц);

	ВсегоРасходовЗаМесяц = СуммаРасходаЗаПериод(ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания);
	
	НовыйРасходДата = ТекущаяДата();	
	
	УстановитьОформлениеЭлементов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьРасходЗаМесяц(Команда)
	ВсегоРасходовЗаМесяц = СуммаРасходаЗаПериод(ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания);
	УстановитьОформлениеЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияАнализРасходовНажатие(Элемент)
	
	ПараметрыДанных = Новый Структура("ПериодОтчета", ПериодОтчета);
	ПользовательскиеНастройки = УстановитьНастройкиОтчета("АнализРасходов", ПараметрыДанных, Неопределено);
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОтчета.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки);
	
	ОткрытьФорму("Отчет.АнализРасходов.Форма", ПараметрыОтчета);	

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРасход(Команда)
	
	Если НЕ РеквизитыРасходаЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРасхода = НовыеПараметрыРасхода();
	
	РасходУжеСуществует = РасходУжеСуществует(ПараметрыРасхода);
	
	Если РасходУжеСуществует Тогда
		ТекстВопроса = Нстр("ru = 'В системе уже существуют данные о расходе с такими параметрами.
					   |Добавить еще раз?'");
		ПараметрыОповещения = Новый Структура("ПараметрыРасхода", ПараметрыРасхода);
		Оповещение = Новый ОписаниеОповещения("ДобавитьРасходПослеВопроса", ЭтотОбъект, ПараметрыОповещения);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
	Иначе
		ДобавитьРасходНаКлиенте(ПараметрыРасхода);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция РеквизитыРасходаЗаполнены()
	
	РеквизитыЗаполнены = Истина;
	
	Если НЕ ЗначениеЗаполнено(НовыйРасходКошелек) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан кошелек", , "НовыйРасходКошелек" , , );
		РеквизитыЗаполнены = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НовыйРасходДата) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указана дата", , "НовыйРасходДата" , , );
		РеквизитыЗаполнены = Ложь;
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(НовыйРасходСтатьяРасходов) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указана статья расходов", , "НовыйРасходСтатьяРасходов" , , );
		РеквизитыЗаполнены = Ложь;
	КонецЕсли;
			
	Если НЕ ЗначениеЗаполнено(НовыйРасходСумма) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указана сумма", , "НовыйРасходСумма" , , );
		РеквизитыЗаполнены = Ложь;
	КонецЕсли;
	
	Возврат РеквизитыЗаполнены;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьРасходПослеВопроса(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьРасходНаКлиенте(ДопПараметры.ПараметрыРасхода);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРасходНаКлиенте(ПараметрыРасхода)
	
	Результат = ДобавитьРасходНаСервере(ПараметрыРасхода);
	
	Если Результат.Успех Тогда
		ПоказатьОповещениеПользователя("Расход добавлен");
	Иначе
		ВызватьИсключение Результат.ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДобавитьРасходНаСервере(ПараметрыРасхода)
	
	Возврат Документы.РегистрацияРасходов.ДобавитьРасход(ПараметрыРасхода);
	
КонецФункции

&НаСервереБезКонтекста
Функция РасходУжеСуществует(ПараметрыРасхода)
	
	Возврат Документы.РегистрацияРасходов.РасходСуществует(ПараметрыРасхода);
	
КонецФункции

&НаКлиенте
Функция НовыеПараметрыРасхода()
	
	ПараметрыРасхода = Новый Структура;
	ПараметрыРасхода.Вставить("Кошелек"				, НовыйРасходКошелек);
	ПараметрыРасхода.Вставить("СтатьяРасходов"		, НовыйРасходСтатьяРасходов);
	ПараметрыРасхода.Вставить("АналитикаРасходов"	, НовыйРасходАналитика);
	ПараметрыРасхода.Вставить("Сумма"				, НовыйРасходСумма);
	ПараметрыРасхода.Вставить("ДатаОперации"		, НовыйРасходДата);
	ПараметрыРасхода.Вставить("Регистратор"			, Неопределено);
	
	Возврат ПараметрыРасхода;
	
КонецФункции

&НаСервереБезКонтекста
Функция УстановитьНастройкиОтчета(ИмяОтчета, ПараметрыДанных, Отборы)
	
	Настройки = КомпоновкаДанныхСервер.УстановитьНастройкиОтчета(ИмяОтчета, ПараметрыДанных, Отборы);
	
	Возврат Настройки;
	
КонецФункции

&НаСервереБезКонтекста
Функция СуммаРасходаЗаПериод(ДатаНачала, ДатаОкончания)
	
	СуммаРасхода = 0;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасходыОбороты.СуммаОборот
	|ИЗ
	|	РегистрНакопления.Расходы.Обороты(&ДатаНачала, &ДатаОкончания,,) КАК РасходыОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СуммаРасхода = Выборка.СуммаОборот;
	КонецЕсли;
	
	Возврат СуммаРасхода;
	
КонецФункции

&НаСервере
Процедура УстановитьОформлениеЭлементов()
	
	ДлинаЧислаРасходы = СтрДлина(Строка(ВсегоРасходовЗаМесяц));
	РасчетнаяШирина = ДлинаЧислаРасходы * 1.5;
	Элементы.ВсегоРасходовЗаМесяц.Ширина = Мин(РасчетнаяШирина, Элементы.ВсегоРасходовЗаМесяц.МаксимальнаяШирина);
	
	ПредставлениеПериода = Строка(ПериодОтчета);
	Элементы.ДекорацияПериод.Заголовок = ПредставлениеПериода;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПериодНажатие(Элемент)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = ПериодОтчета;
	Если Диалог.Редактировать() Тогда 
    	ПериодОтчета = Диалог.Период;
	КонецЕсли;
	
	ОбновитьРасходЗаМесяц(Неопределено);
	
КонецПроцедуры

#КонецОбласти