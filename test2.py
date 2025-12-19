import pytest
from main import *
# Test function for getting students by format
@pytest.mark.parametrize("format_type,expected", [
    ('Дневная', 3),
    ('Заочная', 1),
    ('Вечерняя', 2)
])
def test_get_students_by_format(format_type, expected):
    result = get_students_by_format(format_type)
    assert result == expected

# Test function for getting students by group
@pytest.mark.parametrize("group_number,expected", [
    ('231', 1),
    ('225', 2)
])
def test_get_students_by_group(group_number, expected):
    result = get_students_by_group(group_number)
    assert result == expected

# Test function for getting hours and exam type by specialization
@pytest.mark.parametrize("spec_name,expected", [
    ('DevOps', {'hours': 56, 'exam': 'Зачет'})
])
def test_get_hours_exam_by_spec(spec_name, expected):
    result = get_hours_exam_by_spec(spec_name)
    assert result == expected



# Test function for getting spec ID by subject
@pytest.mark.parametrize("subject_name,expected", [
    ('DevOps', 1)
])
def test_get_spec_id_by_subject(subject_name, expected):
    result = get_spec_id_by_subject(subject_name)
    assert result == expected