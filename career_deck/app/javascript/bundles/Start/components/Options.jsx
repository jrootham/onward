import PropTypes from 'prop-types';
import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';
import Paper from 'material-ui/Paper';
import SelectField from 'material-ui/SelectField';
import DropDownMenu from 'material-ui/DropDownMenu';
import MenuItem from 'material-ui/MenuItem';
import FlatButton from 'material-ui/FlatButton';
import SuperSelectField from 'material-ui-superselectfield'


export default class Options extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = { courseSelection: [], selectedCourses: [] };
    this.loadCareerOptions = () => this._loadCareerOptions();
    this.updateMaesdProgram = (event, index, value) => this._updateMaesdProgram(event, index, value);
    this.submitAndContinue = () => this._submitAndContinue();
    this.fetchCourseOptions = (v) => this._fetchCourseOptions(v);
    this.handleSelectGrade = (v) => this._handleSelectGrade(v);
    this.handleSelectCourse = (course) => this._handleSelectCourse(course);
    this.loadCareerOptions()
  }

  _loadCareerOptions() {
    fetch('/maesd_programs')
      .then( res  => res.json())
      .then( maesdPrograms =>  {
        this.setState({ maesdPrograms });
      })
      .catch( err => console.log(err) )
  }

  _handleSelectCourse(selected) {
    this.setState({ selectedCourses: selected })
    const hsCourseCodes = selected.map(option => option.value).join(',')
    this.props.updateParams('hs_courses', hsCourseCodes)
  }

  _fetchCourseOptions (grade) {
    fetch(`/hs_courses?grade=${grade}`)
      .then(res => res.json())
      .then(json => {
        this.setState({ courseSelection: json })
      })
      .catch(err => console.log(err))
  }

  _handleSelectGrade (value) {
    const level = `grade_${value}`
    return () => {
      this.fetchCourseOptions(value)
      this.props.updateParams('current_level', level)
    }
  }

  _updateMaesdProgram(event, index, value) {
    this.props.updateParams('maesd_codes', value);
  }

  _submitAndContinue() {
    this.setState({ loading: true })

    const url = `/pathways?current_level=${this.props.current_level}&hs_courses=${this.props.hs_courses}&maesd_codes=${this.props.maesd_codes}`

    window.location.href = url;
  }


  render() {
    const options = this.state.maesdPrograms;
    const courseSelection = this.state.courseSelection
    const grades = [9, 10, 11, 12]

    return (
      <div className="page">
        { this.state.loading && <div className="overlay"><div className="loader"></div></div> }
        <div className="form-container">
          <div className="block">
            <p>Answer some <strong>optional</strong> questions to help us narrow down the decks:</p>
          </div>
          <Paper className="block">
              <p>What grade are you in?</p>
              <div className='grade-buttons'>
              {
                grades.map((grade, index) => {
                  const active = this.props.current_level == `grade_${grade}` ? 'active' : ''
                  return <FlatButton key={index} label={grade} onClick={this.handleSelectGrade(grade)} className={`grade-button ${active}`} style={{ backgroundColor: '#E3E3E3'}} />
                })
              }
              </div>
          </Paper>

          <Paper className="block">
              <p>What courses are you taking?</p>
              <SuperSelectField
                multiple
                onChange={this.handleSelectCourse}
                value={this.state.selectedCourses}
                hintText={'Select your courses for this year'}
              >
                {
                  courseSelection.map((course, index) => (
                    <div key={index} value={course.course_code} label={course.course_name_en}>
                      {`${course.course_code}: ${course.course_name_en}`}
                    </div>
                  ))
                }
              </SuperSelectField>
          </Paper>

          <Paper className="block">
            <p>What career field(s) are you interested in?</p>
            <SelectField onChange={ this.updateMaesdProgram } value={ this.props.maesd_codes }>
              {
                options && options.map((program, index) => (
                  <MenuItem
                    key={ index }
                    value={ program.program_code }
                    primaryText={ program.description_en }
                  />
                ))
              }
            </SelectField>
          </Paper>
        </div>
        <div className="btn-container">
          <RaisedButton label='Explore' className='btn primary' onClick={this.submitAndContinue} />
        </div>
      </div>
    );
  }
}
