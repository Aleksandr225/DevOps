from flask import Flask, render_template, request, jsonify, session  
from main import *
app = Flask(__name__)
app.secret_key = '225'


# Формы обучения и предметы
forms_study = ["143", "225", "125", "231"]

exams = ['Зачет', 'Экзамен']


@app.route('/')
def index():
    subjects = get_subjects()
    specs = get_specs()
    return render_template('index.html', forms_study=forms_study, subjects=subjects, exams=exams, specs=specs)

@app.route('/get_student_count', methods=['POST'])
def get_student_count():
    form_study = request.form.get('form_study')
    count = get_students_by_group(form_study)
    return jsonify({"count": count})




@app.route('/get_subject_info', methods=['POST'])
def get_subject_info():
    subject = request.form.get('subject')
    subject_info = get_hours_exam_by_spec(subject)
        
    if subject_info:
        return jsonify(subject_info)
    else:
        return jsonify({"error": "Предмет не найден"}), 404
    

@app.route('/get_subject_info', methods=['POST'])
def process_switch():
    data = request.get_json()
    selected_value = data.get('selected_switch') 
    session['val'] = selected_value
    
    if not selected_value:
        return jsonify({'error': 'Не выбрана опция!'})
    
    

@app.route('/get_student_info', methods=['POST'])
def get_student_info():
    last_name = request.form.get('last_name')
    first_name = request.form.get('first_name')
    subject = request.form.get('subject')
    info = get_all_data(f_name=first_name, s_name=last_name, subject=subject, id=3)
    if info:
        return jsonify(info)
    else:
        return jsonify({"error": "Студент не найден"}), 404
    
@app.route('/alter_data', methods=['POST'])
def update_info():
    data = request.get_json()
    try:
        alter_journal(data)
        return jsonify({'success': True, 'message': 'Информация обновлена'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/add_student', methods=['POST'])
def add_student_n():
    data = request.get_json()
    if not data:
        return jsonify({'success': False, 'error': 'Нет данных'}), 400
    
    try:
        add_student(data)
        add_data(data)
        
        return jsonify({'success': True, 'message': 'Студент добавлен успешно'})
    except Exception as e:
        
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/add_subject', methods=['POST'])
def add_course_n():
    data = request.get_json()
    if not data:
        return jsonify({'success': False, 'error': 'Нет данных'}), 400
    
    try:
        # Предполагаем, что add_student и add_data могут бросать исключения при ошибках
        add_course(data)
        
        return jsonify({'success': True, 'message': 'Студент добавлен успешно'})
    except Exception as e:
        # В случае ошибки возвращаем сообщение об ошибке
        return jsonify({'success': False, 'error': add_course(data)}), 500
    


if __name__ == '__main__':
    app.run(port=5000, host='0.0.0.0')
