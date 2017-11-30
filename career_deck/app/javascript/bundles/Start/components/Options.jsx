import PropTypes from 'prop-types';
import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';
import Paper from 'material-ui/Paper';
import SelectField from 'material-ui/SelectField';
import DropDownMenu from 'material-ui/DropDownMenu';
import MenuItem from 'material-ui/MenuItem';
import FlatButton from 'material-ui/FlatButton';


export default class Options extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {};
    this.loadCareerOptions = () => this._loadCareerOptions();
    this.updateGrade = (v) => this._updateGrade(v);
    this.updateMaesdProgram = (event, index, value) => this._updateMaesdProgram(event, index, value);
    this.submitAndContinue = () => this._submitAndContinue();
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

  _updateGrade (value) {
    const level = `grade_${value}`
    return () => { this.props.updateParams('current_level', level) }
  }

  _updateMaesdProgram(event, index, value) {
    this.props.updateParams('maesd_codes', value);
  }

  _submitAndContinue() {
    window.location.href = `/pathways?current_level=${this.props.current_level}&maesd_codes=${this.props.maesd_codes}`
  }

  render() {
    const options = this.state.maesdPrograms;
    const grades = [9, 10, 11, 12]

    return (
      <div className="page">
        <div className="form-container">
          <div className="block">
            <p>Answer some <strong>optional</strong> questions to help us narrow down the decks</p>
          </div>
          <Paper className="block">
              <p>What grade are you in?</p>
              {
                grades.map((grade, index) => {
                  const active = this.props.current_level == `grade_${grade}` ? 'active' : ''
                  return <FlatButton key={index} label={grade} onClick={this.updateGrade(grade)} className={active} />
                })
              }
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
