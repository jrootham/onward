# README

## ONward Backend

This is the backend for the ONward app, a submission for the Student Pathways Challege.

## API


### Requests

For the pathway search, there's only one endpoint:
```
/pathways
```

It accepts the following query params:
- `hs_courses`: a comma-separated list of high school course codes of the courses the student has taken
- `current_level`: the stage of the career pathway that the student is currently on. The options are `grade_9`, `grade_10`, `grade_11`, `grade_12`, `university`, and `occupation`.

### Response

The response contains the options available for each of the levels of the career path. For grades 9 through 12, those are high school courses.

### Example request

`/pathways?hs_courses=ENG1P,SNC1D,PPL1O&current_level=grade_9`

### Example response

```
{
  "result": {
    "grade_9": [
      {
        "course_code": "SNC1D",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 0
      },
      {
        "course_code": "PPL1O",
        "course_name_en": "Healthy Active Living Education",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 0
      }
    ],
    "grade_10": [
      {
        "course_code": "SNC2D",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SNC2P",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SVN3E",
        "course_name_en": "Environmental Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      }
    ],
    "grade_11": [
      {
        "course_code": "SBI3C",
        "course_name_en": "Biology",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SBI3U",
        "course_name_en": "Biology",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SCH3U",
        "course_name_en": "Chemistry",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SCH4C",
        "course_name_en": "Chemistry",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SES4U",
        "course_name_en": "Earth and Space Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SPH3U",
        "course_name_en": "Physics",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SPH4C",
        "course_name_en": "Physics",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SVN3M",
        "course_name_en": "Environmental Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SBI3C",
        "course_name_en": "Biology",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SCH4C",
        "course_name_en": "Chemistry",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SNC4E",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SPH4C",
        "course_name_en": "Physics",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SVN3M",
        "course_name_en": "Environmental Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      }
    ],
    "grade_12": [
      {
        "course_code": "PSE4U",
        "course_name_en": "Exercise Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SNC4M",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "PSE4U",
        "course_name_en": "Exercise Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SBI4U",
        "course_name_en": "Biology",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SNC4M",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "PSE4U",
        "course_name_en": "Exercise Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SCH4U",
        "course_name_en": "Chemistry",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SNC4M",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "PSE4U",
        "course_name_en": "Exercise Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SNC4M",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SPH4U",
        "course_name_en": "Physics",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "PSE4U",
        "course_name_en": "Exercise Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SNC4M",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "PSE4U",
        "course_name_en": "Exercise Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SNC4M",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "PSE4U",
        "course_name_en": "Exercise Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      },
      {
        "course_code": "SNC4M",
        "course_name_en": "Science",
        "course_name_fr": "nom du cours non disponible",
        "has_prereq": 1
      }
    ],
    "university": [

    ],
    "occupation": [

    ]
  }
}
```

