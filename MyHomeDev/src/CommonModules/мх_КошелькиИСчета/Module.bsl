
#Область ПрограммныйИнтерфейс

Функция ТипыКошельковСобственныхСредств() Экспорт
	
	Возврат Перечисления.мх_ТипыКошельковИСчетов.ТипыКошельковСобственныхСредств();
	
КонецФункции

Функция ТипыКошельковЗаемныхСредств() Экспорт
	
	Возврат Перечисления.мх_ТипыКошельковИСчетов.ТипыКошельковЗаемныхСредств();
	
КонецФункции

// Используемые кошельки по типу.
// 
// Параметры:
//  ТипыКошельков - ПеречислениеСсылка.мх_ТипыКошельковИСчетов - Типы кошельков
// 
// Возвращаемое значение:
//  Массив - Используемые кошельки по типу
Функция ИспользуемыеКошелькиПоТипу(ТипыКошельков) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Типы", ТипыКошельков);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КошелькиИСчета.Ссылка
	|ИЗ
	|	Справочник.мх_КошелькиИСчета КАК КошелькиИСчета
	|ГДЕ
	|	КошелькиИСчета.ТипСчета В (&Типы)
	|	И КошелькиИСчета.Используется";
	
	МассивКошельков = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивКошельков;
	
КонецФункции

#КонецОбласти