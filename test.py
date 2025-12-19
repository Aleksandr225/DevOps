import sqlite3
from main import *  # импортируем ваши функции







def test_get_students_by_format():
    result = get_students_by_format('Дневная')  
    assert result == 3

    result = get_students_by_format('Заочная')  
    assert result == 1

    result = get_students_by_format('Вечерняя')  
    assert result == 2

def test_get_students_by_group():
    result = get_students_by_group('231')  
    assert result == 1

    result = get_students_by_group('225') 
    assert result == 2

def test_get_hours_exam_by_spec():
    result = get_hours_exam_by_spec('DevOps')
    expected_result = {'hours': 56, 'exam': 'Зачет'}
    assert result == expected_result

def test_get_student_id_by_name():
    result = get_student_id_by_name('Альберт', 'Альбертов') 
    assert result == 1


def test_get_spec_id_by_subject():
    result = get_spec_id_by_subject('DevOps')  
    assert result == 1


test_get_spec_id_by_subject()
test_get_student_id_by_name()
test_get_students_by_format()
test_get_students_by_group()