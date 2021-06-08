#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиОбъекта

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;

	мх_ОбработчикиСобытийДокументов.ЗаполнитьРеквизитыДокументаПоШаблону(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	мх_ОбработчикиСобытийДокументов.ЗаполнитьРеквизитыШапкиПоДаннымТабличнойЧасти(ЭтотОбъект,
																				"Товары",
																				"Номенклатура, ГарантийныйСрок", "");
																				
	ЗаполнитьРеквизитыШапкиПоДаннымТабличнойЧасти();

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Документы.мх_Гарантия.ИнициализироватьТаблицыДляДвижений(ЭтотОбъект);

	Документы.мх_Гарантия.ОтразитьДвиженияГарантия(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРеквизитыШапкиПоДаннымТабличнойЧасти()
	
	ЭтотОбъект.КоличествоТоваров = ЭтотОбъект.Товары.Количество();
	
	Если ЭтотОбъект.КоличествоТоваров > 1 Тогда
		
		МассивСроков = ЭтотОбъект.Товары.ВыгрузитьКолонку("ГарантийныйСрок");
		СписокСроков = Новый СписокЗначений();
		СписокСроков.ЗагрузитьЗначения(МассивСроков);
		СписокСроков.СортироватьПоЗначению();
		
		ЭтотОбъект.ГарантийныйСрок = СписокСроков[0].Значение;
		
		РезультатСклонения = ПолучитьСклоненияСтрокиПоЧислу("товар",
													  КоличествоТоваров, 
    												  ,
    												  "ЧС=Количественное",
    												  "ПД=Винительный; ПЧ=Число");
    	Если РезультатСклонения.Количество() > 0 Тогда
    		Номенклатура = РезультатСклонения[0];
    	КонецЕсли;	
				
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли